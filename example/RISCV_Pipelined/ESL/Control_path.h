//
// Created by ludwig on 08.12.16.
//

#ifndef PROJECT_CONTROL_PATH_H
#define PROJECT_CONTROL_PATH_H


#include "systemc.h"
#include "Interfaces.h"
#include "CPU_Interfaces.h"
#include "../../RISCV_commons/Memory_Interfaces.h"
#include "../../RISCV_commons/Utilities.h"
#include "../../RISCV_commons/Defines.h"


class Control_path : public sc_module {
public:

    SC_HAS_PROCESS(Control_path);

    Control_path(sc_module_name name) :
            CPtoME_port("CPtoME_port"),
            MEtoCP_port("MEtoCP_port"),
            CPtoDP_port("CPtoDP_port"),
            DPtoCP_port("DPtoCP_port"),
            section(startup),
            nextsection(startup),
            loadedInst(0x13)
    {
        SC_THREAD(run);
    }

    // ports for communication with memory
    blocking_out<CUtoME_IF> CPtoME_port;
    blocking_in<MEtoCP_IF> MEtoCP_port;

    // ports for communication with data path
    master_out<CPtoDP_IF> CPtoDP_port;
    master_in<DPtoCP_IF> DPtoCP_port;

    // data for communication with memory
    CUtoME_IF CPtoME_data;
    MEtoCP_IF MEtoCP_data;

    // data for communication with decoder
    CPtoDE_IF CPtoDE_data;
    DEtoCP_IF DEtoCP_data;

    // data for communication with data path
    CPtoDP_IF CPtoDP_data;
    DPtoCP_IF DPtoCP_data;

    // data for communication with program counter
    CPtoPC_IF CPtoPC_data;
    PCtoCP_IF PCtoCP_data;

    // control signals for the pipelined stages
    //STAGE_2
    CPtoDP_S3_IF CPtoDP_3_s2;
    CPtoDP_S4_IF CPtoDP_4_s2;
    CPtoDP_S5_IF CPtoDP_5_s2;
    //STAGE_3
    CPtoDP_S3_IF CPtoDP_3_s3;
    CPtoDP_S4_IF CPtoDP_4_s3;
    CPtoDP_S5_IF CPtoDP_5_s3;
    //STAGE_4
    CPtoDP_S4_IF CPtoDP_4_s4;
    CPtoDP_S5_IF CPtoDP_5_s4;
    //STAGE_5
    CPtoDP_S5_IF CPtoDP_5_s5;

    CP_IF CP_data;

    enum Sections {
        startup, IF_writeME_readME, ID_writeDE_readDE, ID_setStallSignals, ID_setDPsignals, ID_writeDP_readDP,
        ID_setPCsignals, ID_writePC_readPC, CP_setPipelineSignals, CP_setStallSignals
    };

    Sections section, nextsection;

    unsigned int loadedInst;

    void run(); // thread

    PC_SelType          DE_pc_sel_s2(CPtoDE_IF CPtoDE_data) const;
    unsigned int        DE_imm_s2(CPtoDE_IF CPtoDE_data) const;
    EncType             DE_enc_type_s2(CPtoDE_IF CPtoDE_data) const;
    InstrType           DE_inst_type_s2(CPtoDE_IF CPtoDE_data) const;
    RF_RD_AccessType    DE_reg_req_s2(CPtoDE_IF CPtoDE_data) const;
    unsigned int        DE_reg_rs1_addr_s2(CPtoDE_IF CPtoDE_data) const;
    unsigned int        DE_reg_rs2_addr_s2(CPtoDE_IF CPtoDE_data) const;
    unsigned int        DE_reg_rd_addr_s2(CPtoDE_IF CPtoDE_data) const;
    AL_FunctionType     DE_alu_fun_s3(CPtoDE_IF CPtoDE_data) const;
    AL_OperandSelType   DE_alu_op1_sel_s3(CPtoDE_IF CPtoDE_data) const;
    AL_OperandSelType   DE_alu_op2_sel_s3(CPtoDE_IF CPtoDE_data) const;
    unsigned int        DE_imm_s3(CPtoDE_IF CPtoDE_data) const;
    ME_AccessType       DE_dmem_req_s4(CPtoDE_IF CPtoDE_data) const;
    ME_MaskType         DE_dmem_mask_s4(CPtoDE_IF CPtoDE_data) const;
    RF_WR_AccessType    DE_reg_req_s5(CPtoDE_IF CPtoDE_data) const;
    RF_WriteDataSelType DE_reg_write_data_sel_s5(CPtoDE_IF CPtoDE_data) const;

    unsigned int        PC(PC_SelType pc_sel_s2, unsigned int imm_s2, bool branchTaken, unsigned int reg1_content, unsigned int pc_reg) const;
    bool                BranchEvaluation(InstrType inst_type, unsigned int reg1_content, unsigned int reg2_content) const;
    bool                StallOnceCalculation(EncType current_enc_type, EncType prev_enc_type, unsigned int reg_rs1_addr_s2, unsigned int reg_rs2_addr_s2, unsigned int reg_rd_addr_s2) const;
    bool                StallTwiceCalculation(EncType current_enc_type, EncType prev_enc_type, unsigned int reg_rs1_addr_s2, unsigned int reg_rs2_addr_s2, unsigned int reg_rd_addr_s2) const;
};


void Control_path::run() {

    while (true) {

        if (section == startup) {
            CPtoDP_data.stall_dmem_access_s4 = false;
            PCtoCP_data.pc = 0;
            nextsection = IF_writeME_readME;
        }

        if (section == IF_writeME_readME) {

            if (CP_data.dmem_access_s5) {

                CPtoME_data.req = DPtoCP_data.req;
                CPtoME_data.mask = DPtoCP_data.mask;
                CPtoME_data.addrIn = DPtoCP_data.addrIn;
                CPtoME_data.dataIn = DPtoCP_data.dataIn;

            } else {

                CPtoME_data.req = ME_RD;
                CPtoME_data.mask = MT_W; // always for instructions
                CPtoME_data.addrIn = PCtoCP_data.pc;
                CPtoME_data.dataIn = 0;
            }

            CPtoME_port->write(CPtoME_data); //Send request to memory

            MEtoCP_port->read(MEtoCP_data);  //Read decoded instruction from decoder

            if (CP_data.dmem_access_s5) {
                CPtoDP_data.loadedData_s5 = MEtoCP_data.loadedData;
            } else {
                CPtoDP_data.loadedData_s5 = 0;
            }

            // Terminate if:
            if (MEtoCP_data.loadedData == 0X00000F93) {

#ifdef LOGTOFILE
                cout << "@CP: End of program... Terminating!" << endl;
#endif
            sc_stop();
            wait(SC_ZERO_TIME);
            }

            nextsection = ID_writeDE_readDE;
        }

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

        if (section == ID_writeDE_readDE) {

            if (!CPtoPC_data.stall) {
                CPtoDE_data.encodedInst = loadedInst;
            }

            DEtoCP_data.pc_sel_s2             = DE_pc_sel_s2(CPtoDE_data);
            DEtoCP_data.imm_s2                = DE_imm_s2(CPtoDE_data);
            DEtoCP_data.enc_type_s2           = DE_enc_type_s2(CPtoDE_data);
            DEtoCP_data.inst_type_s2          = DE_inst_type_s2(CPtoDE_data);
            DEtoCP_data.reg_req_s2            = DE_reg_req_s2(CPtoDE_data);
            DEtoCP_data.reg_rs1_addr_s2       = DE_reg_rs1_addr_s2(CPtoDE_data);
            DEtoCP_data.reg_rs2_addr_s2       = DE_reg_rs2_addr_s2(CPtoDE_data);
            DEtoCP_data.reg_rd_addr_s2        = DE_reg_rd_addr_s2(CPtoDE_data);
            DEtoCP_data.alu_fun_s3            = DE_alu_fun_s3(CPtoDE_data);
            DEtoCP_data.alu_op1_sel_s3        = DE_alu_op1_sel_s3(CPtoDE_data);
            DEtoCP_data.alu_op2_sel_s3        = DE_alu_op2_sel_s3(CPtoDE_data);
            DEtoCP_data.imm_s3                = DE_imm_s3(CPtoDE_data);
            DEtoCP_data.dmem_req_s4           = DE_dmem_req_s4(CPtoDE_data);
            DEtoCP_data.dmem_mask_s4          = DE_dmem_mask_s4(CPtoDE_data);
            DEtoCP_data.reg_req_s5            = DE_reg_req_s5(CPtoDE_data);
            DEtoCP_data.reg_write_data_sel_s5 = DE_reg_write_data_sel_s5(CPtoDE_data);

#ifdef LOGTOFILE
            cout << endl << "S2: @DE: Decoding Inst 0x" << hex << CPtoDE_data.encodedInst << ", InstrType = "
                 << stringInstrType(DEtoCP_data.inst_type_s2) << endl;

            if (DEtoCP_data.enc_type_s2 == ENC_I_J || DEtoCP_data.enc_type_s2 == ENC_B || DEtoCP_data.enc_type_s2 == ENC_J) {
                cout << "S2: @DE: Immediate = 0x" << hex << DEtoCP_data.imm_s2 << "(hex) = "
                     << dec << DEtoCP_data.imm_s2 << " (dec)" << endl;
            } else {
                cout << "S2: @DE: Immediate = 0x" << hex << DEtoCP_data.imm_s3 << "(hex) = "
                     << dec << DEtoCP_data.imm_s3 << " (dec)" << endl;
            }
#endif

            if (!CPtoPC_data.stall) {
                loadedInst = MEtoCP_data.loadedData;
            }

            if (/*!CP_data.flush &&*/ !CPtoPC_data.stall && CPtoDP_data.reg_rd_addr_s2 != 0) {
                nextsection = ID_setStallSignals;
            } else {
                nextsection = ID_setDPsignals;
            }
        }

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

        if (section == ID_setStallSignals) {

            CP_data.stall_once = StallOnceCalculation(DEtoCP_data.enc_type_s2, CPtoDP_data.enc_type_s2, DEtoCP_data.reg_rs1_addr_s2, DEtoCP_data.reg_rs2_addr_s2, CPtoDP_data.reg_rd_addr_s2);
            CP_data.stall_twice = StallTwiceCalculation(DEtoCP_data.enc_type_s2, CPtoDP_data.enc_type_s2, DEtoCP_data.reg_rs1_addr_s2, DEtoCP_data.reg_rs2_addr_s2, CPtoDP_data.reg_rd_addr_s2);

#ifdef LOGTOFILE
            if (CPtoDP_data.stall_dmem_access_s4) {
                cout << "S2: @CP: .~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~STALL THE PIPELINE MEM ACCESS~.~.~.~.~.~.~.~.~.~.~.~.~.~.  " <<  endl;
            } else if (CP_data.stall_twice) {
                cout << "S2: @CP: .~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~STALL THE PIPELINE TWICE~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.  " << stringInstrType(CPtoDP_data.inst_type_s2)
                     << "   ~~>   " << stringInstrType(DEtoCP_data.inst_type_s2) << endl;
            } else if (CP_data.stall_once){
                cout << "S2: @CP: .~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~STALL THE PIPELINE ONCE~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.  " << stringInstrType(CPtoDP_data.inst_type_s2)
                     << "   ~~>   " << stringInstrType(DEtoCP_data.inst_type_s2) << endl;
            }
#endif
            nextsection = ID_setDPsignals;
        }

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

        if (section == ID_setDPsignals) {

            DPtoCP_port->read(DPtoCP_data); //++++++++++++++++++++++++++

            if (CP_data.flush && CP_data.dmem_access_s5) {  //++++++++++++++++++++++++++
                CPtoPC_data.reg1_content = CP_data.reg1_content; //++++++++++++++++++++++++++
                CPtoPC_data.branchTaken = true; //++++++++++++++++++++++++++
            } else { //++++++++++++++++++++++++++
                CPtoPC_data.reg1_content = DPtoCP_data.reg1_content; //++++++++++++++++++++++++++
                CPtoPC_data.branchTaken = BranchEvaluation(CP_data.instType_s3, DPtoCP_data.reg1_content, DPtoCP_data.reg2_content); //++++++++++++++++++++++++++
            } //++++++++++++++++++++++++++

            if (!CP_data.stall_once && !CP_data.stall_twice && CPtoDP_data.enc_type_s2 != ENC_J && CPtoDP_data.enc_type_s2 != ENC_I_J && !CPtoPC_data.branchTaken) {
                if ((DEtoCP_data.enc_type_s2 == ENC_I_J && CP_data.encType_s4 == ENC_I_L && DEtoCP_data.reg_rs1_addr_s2 == CP_data.reg_rd_addr_s4 && CP_data.reg_rd_addr_s4 != 0) ||
                    (DEtoCP_data.enc_type_s2 == ENC_B && CP_data.encType_s4 == ENC_I_L && (DEtoCP_data.reg_rs1_addr_s2 == CP_data.reg_rd_addr_s4 ||
                                                                                           DEtoCP_data.reg_rs2_addr_s2 == CP_data.reg_rd_addr_s4) && CP_data.reg_rd_addr_s4 != 0)   ) {
                    CP_data.stall_once = true; //++++++++++++++++++++++++++
                } else if (CP_data.prev_memory_access &&
                           ((DEtoCP_data.enc_type_s2 == ENC_I_J && CP_data.encType_s5 == ENC_I_L && DEtoCP_data.reg_rs1_addr_s2 == CP_data.reg_rd_addr_s5 && CP_data.reg_rd_addr_s5 != 0) ||
                           (DEtoCP_data.enc_type_s2 == ENC_B && CP_data.encType_s5 == ENC_I_L && (DEtoCP_data.reg_rs1_addr_s2 == CP_data.reg_rd_addr_s5 ||
                                                                                                  DEtoCP_data.reg_rs2_addr_s2 == CP_data.reg_rd_addr_s5) && CP_data.reg_rd_addr_s5 != 0)))
                        {
                    CP_data.stall_once = true; //++++++++++++++++++++++++++
                } else {
                    CP_data.stall_once = false; //++++++++++++++++++++++++++
                }
            }

            if (CP_data.dmem_access_s5) {
                CPtoDP_data.prev_memory_access = true;
                CP_data.prev_memory_access = true;
            } else {
                CPtoDP_data.prev_memory_access = false;
                CP_data.prev_memory_access = false;
            }

            //cout << stringInstrType(CP_data.instType_s5) << "   " << stringInstrType(CP_data.instType_s4) << "   " << stringInstrType(CPtoDP_data.inst_type_s2) << "   " << stringInstrType(DEtoCP_data.inst_type_s2) << endl;

            CP_data.encType_s5 = CP_data.encType_s4;
            CP_data.reg_rd_addr_s5 = CP_data.reg_rd_addr_s4;

            CP_data.encType_s4 = CPtoDP_data.enc_type_s2;
            CP_data.reg_rd_addr_s4 = CPtoDP_data.reg_rd_addr_s2;

            if (CP_data.dmem_access) {
                CP_data.flush_dmem_access = true;
            } else {
                CP_data.flush_dmem_access = false;
            }

            if ((CPtoDP_data.enc_type_s2 == ENC_J && CPtoDP_data.stall_dmem_access_s4) || (CP_data.flush && (CPtoDP_data.stall_dmem_access_s4 || CP_data.dmem_access_s5))) {
                CP_data.dmem_access = true;
            } else {
                CP_data.dmem_access = false;
            }

            if (CPtoPC_data.branchTaken || CP_data.flush_dmem_access || CP_data.flush || CPtoDP_data.stall_dmem_access_s4 || CP_data.stall_once || CP_data.stall_twice || CPtoDP_data.enc_type_s2 == ENC_J || CPtoDP_data.enc_type_s2 == ENC_I_J ) {

                CPtoPC_data.pc_sel_s2 = PC_4;
                CPtoPC_data.imm_s2 = 0;

                CPtoDP_data.enc_type_s2 = ENC_I_I;
                CPtoDP_data.inst_type_s2 = InstrType::INSTR_ADDI; // for debugging
                CP_data.instType_s2 = InstrType::INSTR_ADDI;

                CPtoDP_data.reg_req_s2 = RF_RD_X;
                CPtoDP_data.reg_rs1_addr_s2 = 0;
                CPtoDP_data.reg_rs2_addr_s2 = 0;
                CPtoDP_data.reg_rd_addr_s2 = 0;

                CPtoDP_3_s2.alu_fun_s3 = ALU_X;
                CPtoDP_3_s2.alu_op1_sel_s3 = OP_X;
                CPtoDP_3_s2.alu_op2_sel_s3 = OP_X;
                CPtoDP_3_s2.imm_s3 = 0;

                CPtoDP_4_s2.dmem_req_s4 = ME_X;
                CPtoDP_4_s2.dmem_mask_s4 = MT_X;

                CPtoDP_5_s2.reg_req_s5 = RF_WR_X;
                CPtoDP_5_s2.reg_write_data_sel_s5 = WB_X;

            } else {

                CPtoPC_data.pc_sel_s2 = DEtoCP_data.pc_sel_s2;
                CPtoPC_data.imm_s2 = DEtoCP_data.imm_s2;

                CPtoDP_data.enc_type_s2 = DEtoCP_data.enc_type_s2;
                CPtoDP_data.inst_type_s2 = DEtoCP_data.inst_type_s2; // for debugging
                CP_data.instType_s2 = DEtoCP_data.inst_type_s2;

                CPtoDP_data.reg_req_s2 = DEtoCP_data.reg_req_s2;
                CPtoDP_data.reg_rs1_addr_s2 = DEtoCP_data.reg_rs1_addr_s2;
                CPtoDP_data.reg_rs2_addr_s2 = DEtoCP_data.reg_rs2_addr_s2;
                CPtoDP_data.reg_rd_addr_s2 = DEtoCP_data.reg_rd_addr_s2;

                CPtoDP_3_s2.alu_fun_s3 = DEtoCP_data.alu_fun_s3;
                CPtoDP_3_s2.alu_op1_sel_s3 = DEtoCP_data.alu_op1_sel_s3;
                CPtoDP_3_s2.alu_op2_sel_s3 = DEtoCP_data.alu_op2_sel_s3;
                CPtoDP_3_s2.imm_s3 = DEtoCP_data.imm_s3;

                CPtoDP_4_s2.dmem_req_s4 = DEtoCP_data.dmem_req_s4;
                CPtoDP_4_s2.dmem_mask_s4 = DEtoCP_data.dmem_mask_s4;

                CPtoDP_5_s2.reg_req_s5 = DEtoCP_data.reg_req_s5;
                CPtoDP_5_s2.reg_write_data_sel_s5 = DEtoCP_data.reg_write_data_sel_s5;
            }

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

            CPtoDP_data.alu_fun_s3 = CPtoDP_3_s3.alu_fun_s3;
            CPtoDP_data.alu_op1_sel_s3 = CPtoDP_3_s3.alu_op1_sel_s3;
            CPtoDP_data.alu_op2_sel_s3 = CPtoDP_3_s3.alu_op2_sel_s3;
            CPtoDP_data.imm_s3 = CPtoDP_3_s3.imm_s3;

            CPtoDP_data.dmem_req_s4 = CPtoDP_4_s4.dmem_req_s4;
            CPtoDP_data.dmem_mask_s4 = CPtoDP_4_s4.dmem_mask_s4;

            CPtoDP_data.reg_req_s5 = CPtoDP_5_s5.reg_req_s5;
            CPtoDP_data.reg_write_data_sel_s5 = CPtoDP_5_s5.reg_write_data_sel_s5;

            nextsection = ID_writeDP_readDP;
        }

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

        if (section == ID_writeDP_readDP) {

            //DPtoCP_port->read(DPtoCP_data);

            CPtoDP_port->write(CPtoDP_data);

            nextsection = ID_setPCsignals;
        }

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

        if (section == ID_setPCsignals) {

            if (CPtoDP_data.stall_dmem_access_s4 || CP_data.stall_once || CP_data.stall_twice) {
                CPtoPC_data.stall = true;
            } else {
                CPtoPC_data.stall = false;
            }

            /*if (CP_data.getOldPCvalues) {
                CPtoPC_data.reg1_content = CP_data.reg1_content;
                CPtoPC_data.branchTaken = true;
            } else {
                CPtoPC_data.reg1_content = DPtoCP_data.reg1_content;
                CPtoPC_data.branchTaken = BranchEvaluation(CP_data.instType_s3, DPtoCP_data.reg1_content, DPtoCP_data.reg2_content);
            }*/

            //if (CP_data.prevInst_JR || (/*CP_data.prevInst_B &&*/ CPtoPC_data.branchTaken)) { //++++++++ || (CP_data.flush && CP_data.dmem_access_s5) could be deleted++++++++++++++++++
                //CPtoPC_data.pc_sel_s2 = CP_data.pc_sel;
                //CPtoPC_data.imm_s2 = CP_data.pc_imm;
            //}

            //if ((CP_data.prevInst_JR || (/*CP_data.prevInst_B &&*/ CPtoPC_data.branchTaken)) && CPtoDP_data.stall_dmem_access_s4) {
               // CP_data.getOldPCvalues = true;
               // CP_data.reg1_content = DPtoCP_data.reg1_content;
            //} else {
               // CP_data.getOldPCvalues = false;
              //  CP_data.reg1_content = 0;
            //}


            if (CP_data.prevInst_JR || (/*CP_data.prevInst_B &&*/ CPtoPC_data.branchTaken)) {
                CP_data.flush = true;
                CP_data.reg1_content = DPtoCP_data.reg1_content; //++++++++++++++++++++++++++
                CPtoPC_data.pc_sel_s2 = CP_data.pc_sel; //++++++++++++++++++++++++++
                CPtoPC_data.imm_s2 = CP_data.pc_imm; //++++++++++++++++++++++++++
            } else {
                CP_data.flush = false;
                CP_data.reg1_content = 0; //++++++++++++++++++++++++++
            }

            /*if (CP_data.prevInst_B && CPtoPC_data.branchTaken) {
                CPtoDP_data.flush_branch = true;
            } else {
                CPtoDP_data.flush_branch = false;
            }*/

            if ((CPtoDP_data.enc_type_s2 == ENC_I_J || CPtoDP_data.enc_type_s2 == ENC_B)/* && !CPtoPC_data.branchTaken*/) {
                CP_data.pc_sel = DEtoCP_data.pc_sel_s2;
                CP_data.pc_imm = DEtoCP_data.imm_s2;
                CPtoPC_data.pc_sel_s2 = PC_4;
                CPtoPC_data.imm_s2 = 0;

                if (CPtoDP_data.enc_type_s2 == ENC_I_J) {
                    CP_data.prevInst_JR = true;
                    /*CP_data.prevInst_B = false;*/
                } else {
                    CP_data.prevInst_JR = false; //++++++++++++++++++++++++++
                }

                /*if (CPtoDP_data.enc_type_s2 == ENC_B) {
                    CP_data.prevInst_B = true;
                    CP_data.prevInst_JR = false;
                }*/
            } else {
                CP_data.prevInst_JR = false;
                /*CP_data.prevInst_B = false;*/
            }

            CP_data.instType_s5 = CP_data.instType_s4; // for debugging

            CP_data.instType_s4 = CP_data.instType_s3; // for debugging

            CP_data.instType_s3 = CP_data.instType_s2;

            nextsection = ID_writePC_readPC;
        }

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

        if (section == ID_writePC_readPC) {

            if (!CPtoPC_data.stall) {

                CPtoDP_data.pc_s2 = PCtoCP_data.pc;

                PCtoCP_data.pc = PC(CPtoPC_data.pc_sel_s2, CPtoPC_data.imm_s2, CPtoPC_data.branchTaken, CPtoPC_data.reg1_content, CPtoDP_data.pc_s2);

            }

            if(!CPtoDP_data.stall_dmem_access_s4) {
                nextsection = CP_setPipelineSignals;
            } else {
                nextsection = CP_setStallSignals;
            }
        }

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

        if (section == CP_setPipelineSignals) {

            CPtoDP_5_s5.reg_req_s5 = CPtoDP_5_s4.reg_req_s5;
            CPtoDP_5_s5.reg_write_data_sel_s5 = CPtoDP_5_s4.reg_write_data_sel_s5;

            CPtoDP_4_s4.dmem_req_s4 = CPtoDP_4_s3.dmem_req_s4;
            CPtoDP_4_s4.dmem_mask_s4 = CPtoDP_4_s3.dmem_mask_s4;
            CPtoDP_5_s4.reg_req_s5 = CPtoDP_5_s3.reg_req_s5;
            CPtoDP_5_s4.reg_write_data_sel_s5 = CPtoDP_5_s3.reg_write_data_sel_s5;

            /*if (CPtoPC_data.branchTaken) {
                CPtoDP_3_s3.alu_fun_s3 = ALU_X;
                CPtoDP_3_s3.alu_op1_sel_s3 = OP_X;
                CPtoDP_3_s3.alu_op2_sel_s3 = OP_X;
                CPtoDP_3_s3.imm_s3 = 0;
                CPtoDP_4_s3.dmem_req_s4 = ME_X;
                CPtoDP_4_s3.dmem_mask_s4 = MT_X;
                CPtoDP_5_s3.reg_req_s5 = RF_WR_X;
                CPtoDP_5_s3.reg_write_data_sel_s5 = WB_X;
            } else {*/
                CPtoDP_3_s3.alu_fun_s3 = CPtoDP_3_s2.alu_fun_s3;
                CPtoDP_3_s3.alu_op1_sel_s3 = CPtoDP_3_s2.alu_op1_sel_s3;
                CPtoDP_3_s3.alu_op2_sel_s3 = CPtoDP_3_s2.alu_op2_sel_s3;
                CPtoDP_3_s3.imm_s3 = CPtoDP_3_s2.imm_s3;
                CPtoDP_4_s3.dmem_req_s4 = CPtoDP_4_s2.dmem_req_s4;
                CPtoDP_4_s3.dmem_mask_s4 = CPtoDP_4_s2.dmem_mask_s4;
                CPtoDP_5_s3.reg_req_s5 = CPtoDP_5_s2.reg_req_s5;
                CPtoDP_5_s3.reg_write_data_sel_s5 = CPtoDP_5_s2.reg_write_data_sel_s5;
            //}

            nextsection = CP_setStallSignals;
        }

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

        if (section == CP_setStallSignals) {

            if (CPtoDP_data.stall_dmem_access_s4) {
                CP_data.dmem_access_s5 = true;
            } else {
                CP_data.dmem_access_s5 = false;
            }

            if ((CPtoDP_data.dmem_req_s4 == ME_RD || CPtoDP_data.dmem_req_s4 == ME_WR) && !CP_data.dmem_access_s5) {
                CPtoDP_data.stall_dmem_access_s4 = true;
            } else {
                CPtoDP_data.stall_dmem_access_s4 = false;
            }

            if ((CP_data.dmem_access_s5) && CP_data.stall_twice) {
                CP_data.stall_twice = true;
                CP_data.stall_once = false;
            } else if ((CP_data.dmem_access_s5) && CP_data.stall_once) {
                CP_data.stall_once = true;
                CP_data.stall_twice = false;
            } else if (CP_data.stall_twice) {
                CP_data.stall_once = true;
                CP_data.stall_twice = false;
            } else {
                CP_data.stall_once = false;
                CP_data.stall_twice = false;
            }

            nextsection = IF_writeME_readME;
        }

        section = nextsection;
    }
}

bool Control_path::StallOnceCalculation(EncType current_enc_type, EncType prev_enc_type, unsigned int reg_rs1_addr_s2, unsigned int reg_rs2_addr_s2, unsigned int reg_rd_addr_s2) const {

    ////////////////////////////////////////////////////////////////////////////////////////////
    //| STALL_1 || Target register is the same register that would be read by the following inst
    ////////////////////////////////////////////////////////////////////////////////////////////
    //| CASE_1  ||    {R | I_I | U} ~~> {B}   ||           STALL_NUM: (02 | 04 | 12)
    ////////////////////////////////////////////////////////////////////////////////////////////
    //| CASE_2  ||        {I_L} ~~> {R}       ||                STALL_NUM: (05)
    ////////////////////////////////////////////////////////////////////////////////////////////
    if ((((current_enc_type == ENC_B) && (prev_enc_type == ENC_R || prev_enc_type == ENC_I_I || prev_enc_type == ENC_U)) || (current_enc_type == ENC_R && prev_enc_type == ENC_I_L)) &&
        ((reg_rs1_addr_s2 == reg_rd_addr_s2) || (reg_rs2_addr_s2 == reg_rd_addr_s2))) {

        return true;

        ////////////////////////////////////////////////////////////////////////////////////////////
        //| STALL_2 || Target register is the same register that would be read by the following inst
        ////////////////////////////////////////////////////////////////////////////////////////////
        //| CASE_1  ||        {I_L} ~~> {B}       ||                STALL_NUM: (10)
        ////////////////////////////////////////////////////////////////////////////////////////////
    } else if ((current_enc_type == ENC_B) && (prev_enc_type == ENC_I_L) && ((reg_rs1_addr_s2 == reg_rd_addr_s2) || (reg_rs2_addr_s2 == reg_rd_addr_s2))) {

        return false;

        ////////////////////////////////////////////////////////////////////////////////////////////
        //| STALL_3 || Target register is the same register that would be read by the following inst
        ////////////////////////////////////////////////////////////////////////////////////////////
        //| CASE_1  ||    {I_L} ~~> {I_I | I_L}   ||             STALL_NUM: (06 | 07)
        ////////////////////////////////////////////////////////////////////////////////////////////
        //| CASE_2  ||   {R | I_I | U} ~~> {I_J}  ||           STALL_NUM: (01 | 03 | 11)
        ////////////////////////////////////////////////////////////////////////////////////////////
    } else if ((((current_enc_type == ENC_I_I || current_enc_type == ENC_I_L || current_enc_type == ENC_S) && prev_enc_type == ENC_I_L) ||
                (current_enc_type == ENC_I_J && (prev_enc_type == ENC_R || prev_enc_type == ENC_I_I || prev_enc_type == ENC_U))) && (reg_rs1_addr_s2 == reg_rd_addr_s2)) {

        return true;

        ////////////////////////////////////////////////////////////////////////////////////////////
        //| STALL_4 || Target register is the same register that would be read by the following inst
        ////////////////////////////////////////////////////////////////////////////////////////////
        //| CASE_1  ||    {I_L} ~~> {I_J | S}     ||             STALL_NUM: (08 | 09)
        ////////////////////////////////////////////////////////////////////////////////////////////
    } else if (((current_enc_type == ENC_I_J /*|| current_enc_type == ENC_S*/) && prev_enc_type == ENC_I_L) && (reg_rs1_addr_s2 == reg_rd_addr_s2)) {

        return false;

    } else {
        return false;
    }
}

bool Control_path::StallTwiceCalculation(EncType current_enc_type, EncType prev_enc_type, unsigned int reg_rs1_addr_s2, unsigned int reg_rs2_addr_s2, unsigned int reg_rd_addr_s2) const {

    ////////////////////////////////////////////////////////////////////////////////////////////
    //| STALL_1 || Target register is the same register that would be read by the following inst
    ////////////////////////////////////////////////////////////////////////////////////////////
    //| CASE_1  ||    {R | I_I | U} ~~> {B}   ||           STALL_NUM: (02 | 04 | 12)
    ////////////////////////////////////////////////////////////////////////////////////////////
    //| CASE_2  ||        {I_L} ~~> {R}       ||                STALL_NUM: (05)
    ////////////////////////////////////////////////////////////////////////////////////////////
    if ((((current_enc_type == ENC_B) && (prev_enc_type == ENC_R || prev_enc_type == ENC_I_I || prev_enc_type == ENC_U)) || (current_enc_type == ENC_R && prev_enc_type == ENC_I_L)) &&
        ((reg_rs1_addr_s2 == reg_rd_addr_s2) || (reg_rs2_addr_s2 == reg_rd_addr_s2))) {

        return false;

        ////////////////////////////////////////////////////////////////////////////////////////////
        //| STALL_2 || Target register is the same register that would be read by the following inst
        ////////////////////////////////////////////////////////////////////////////////////////////
        //| CASE_1  ||        {I_L} ~~> {B}       ||                STALL_NUM: (10)
        ////////////////////////////////////////////////////////////////////////////////////////////
    } else if ((current_enc_type == ENC_B) && (prev_enc_type == ENC_I_L) && ((reg_rs1_addr_s2 == reg_rd_addr_s2) || (reg_rs2_addr_s2 == reg_rd_addr_s2))) {

        return true;

        ////////////////////////////////////////////////////////////////////////////////////////////
        //| STALL_3 || Target register is the same register that would be read by the following inst
        ////////////////////////////////////////////////////////////////////////////////////////////
        //| CASE_1  ||    {I_L} ~~> {I_I | I_L}   ||             STALL_NUM: (06 | 07)
        ////////////////////////////////////////////////////////////////////////////////////////////
        //| CASE_2  ||   {R | I_I | U} ~~> {I_J}  ||           STALL_NUM: (01 | 03 | 11)
        ////////////////////////////////////////////////////////////////////////////////////////////
    } else if ((((current_enc_type == ENC_I_I || current_enc_type == ENC_I_L || current_enc_type == ENC_S) && prev_enc_type == ENC_I_L) ||
                (current_enc_type == ENC_I_J && (prev_enc_type == ENC_R || prev_enc_type == ENC_I_I || prev_enc_type == ENC_U))) && (reg_rs1_addr_s2 == reg_rd_addr_s2)) {

        return false;

        ////////////////////////////////////////////////////////////////////////////////////////////
        //| STALL_4 || Target register is the same register that would be read by the following inst
        ////////////////////////////////////////////////////////////////////////////////////////////
        //| CASE_1  ||    {I_L} ~~> {I_J | S}     ||             STALL_NUM: (08 | 09)
        ////////////////////////////////////////////////////////////////////////////////////////////
    } else if (((current_enc_type == ENC_I_J /*|| current_enc_type == ENC_S*/) && prev_enc_type == ENC_I_L) && (reg_rs1_addr_s2 == reg_rd_addr_s2)) {

        return true;

    } else {

        return false;
    }
}

bool Control_path::BranchEvaluation(InstrType inst_type, unsigned int reg1_content, unsigned int reg2_content) const {

    if (inst_type == InstrType::INSTR_BEQ && (reg1_content + (-reg2_content)) == 0) {
        return true;
    } else if (inst_type == InstrType::INSTR_BNE && (reg1_content + (-reg2_content)) != 0) {
        return true;
    } else if (inst_type == InstrType::INSTR_BLT && (static_cast<int>(reg1_content) < static_cast<int>(reg2_content))) {
        return true;
    } else if (inst_type == InstrType::INSTR_BGE && (static_cast<int>(reg1_content) >= static_cast<int>(reg2_content))) {
        return true;
    } else if (inst_type == InstrType::INSTR_BLTU && (reg1_content < reg2_content)) {
        return true;
    } else if (inst_type == InstrType::INSTR_BGEU && (reg1_content >= reg2_content)) {
        return true;
    } else {
        return false;
    }
}

unsigned int Control_path::PC(PC_SelType pc_sel_s2, unsigned int imm_s2, bool branchTaken, unsigned int reg1_content, unsigned int pc_reg) const {

    if (pc_sel_s2 == PC_BR) {
        if (branchTaken) {
            return pc_reg - 8 + imm_s2;
#ifdef LOGTOFILE
            cout << "S2: @PC: .~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~BRANCH TAKEN~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~." << endl;
#endif
        } else {
            return pc_reg + 4;
#ifdef LOGTOFILE
            cout << "S2: @PC: .~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~BRANCH NOT TAKEN~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~" << endl;
#endif
        }
    } else if (pc_sel_s2 == PC_J) {
        return pc_reg - 4 + imm_s2;
    } else if (pc_sel_s2 == PC_JR) {
        return reg1_content + imm_s2;
    } else {
        return pc_reg + 4;
    }
}

PC_SelType Control_path::DE_pc_sel_s2(CPtoDE_IF CPtoDE_data) const {

    if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x33) {
        return PC_4;
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x13) {
        return PC_4;
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x03) {
        return PC_4;
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x67) {
        return PC_JR;
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x23) {
        return PC_4;
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x63) {
        return PC_BR;
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x37) {
        return PC_4;
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x17) {
        return PC_4;
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x6F) {
        return PC_J;
    } else {
        return PC_4;
    }
}

unsigned int Control_path::DE_imm_s2(CPtoDE_IF CPtoDE_data) const {

    if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x33) {
        return 0;
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x13) {
        return 0;
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x03) {
        return 0;
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x67) {
        if (Sub(CPtoDE_data.encodedInst, 31, 31) == 1) {
            return Cat(Fill(20), 20, Sub(CPtoDE_data.encodedInst, 31, 20), 12);
        } else {
            return Sub(CPtoDE_data.encodedInst, 31, 20);
        }
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x23) {
        return 0;
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x63) {
        if (Sub(CPtoDE_data.encodedInst, 31, 31) == 1) {
            return Cat(Cat(Fill(19), 19, Cat(Cat(Sub(CPtoDE_data.encodedInst, 31, 31), 1, Sub(CPtoDE_data.encodedInst, 7, 7), 1), 2, Cat(Sub(CPtoDE_data.encodedInst, 30, 25), 6, Sub(CPtoDE_data.encodedInst, 11, 8), 4), 10), 12), 31, 0, 1);
        } else {
            return Cat(Cat(Cat(Sub(CPtoDE_data.encodedInst, 31, 31), 1, Sub(CPtoDE_data.encodedInst, 7, 7), 1), 2, Cat(Sub(CPtoDE_data.encodedInst, 30, 25), 6, Sub(CPtoDE_data.encodedInst, 11, 8), 4), 10), 31, 0, 1);
        }
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x37) {
        return 0;
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x17) {
        return 0;
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x6F) {
        if (Sub(CPtoDE_data.encodedInst, 31, 31) == 1) {
            return Cat(Cat(Fill(11), 11, Cat(Cat(Sub(CPtoDE_data.encodedInst, 31, 31), 1, Sub(CPtoDE_data.encodedInst, 19, 12), 8), 9, Cat(Sub(CPtoDE_data.encodedInst, 20, 20), 1, Sub(CPtoDE_data.encodedInst, 30, 21), 10), 11), 20), 31, 0, 1);
        } else {
            return Cat(Cat(Cat(Sub(CPtoDE_data.encodedInst, 31, 31), 1, Sub(CPtoDE_data.encodedInst, 19, 12), 8), 9, Cat(Sub(CPtoDE_data.encodedInst, 20, 20), 1, Sub(CPtoDE_data.encodedInst, 30, 21), 10), 11), 31, 0, 1);
        }
    } else {
        return 0;
    }
}

EncType Control_path::DE_enc_type_s2(CPtoDE_IF CPtoDE_data) const {

    if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x33) {
        return ENC_R;
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x13) {
        return ENC_I_I;
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x03) {
        return ENC_I_L;
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x67) {
        return ENC_I_J;
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x23) {
        return ENC_S;
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x63) {
        return ENC_B;
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x37) {
        return ENC_U;
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x17) {
        return ENC_U;
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x6F) {
        return ENC_J;
    } else {
        return ENC_ERR;
    }
}

InstrType Control_path::DE_inst_type_s2(CPtoDE_IF CPtoDE_data) const {

    if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x33) {
        if (Sub(CPtoDE_data.encodedInst, 14, 12) == 0x0) {
            if (Sub(CPtoDE_data.encodedInst, 31, 25) == 0) {
                return InstrType::INSTR_ADD;
            } else if (Sub(CPtoDE_data.encodedInst, 31, 25) == 32) {
                return InstrType::INSTR_SUB;
            } else {
                return InstrType::INSTR_UNKNOWN;
            }
        } else if (Sub(CPtoDE_data.encodedInst, 14, 12) == 0x01) {
            return InstrType::INSTR_SLL;
        } else if (Sub(CPtoDE_data.encodedInst, 14, 12) == 0x02) {
            return InstrType::INSTR_SLT;
        } else if (Sub(CPtoDE_data.encodedInst, 14, 12) == 0x03) {
            return InstrType::INSTR_SLTU;
        } else if (Sub(CPtoDE_data.encodedInst, 14, 12) == 0x04) {
            return InstrType::INSTR_XOR;
        } else if (Sub(CPtoDE_data.encodedInst, 14, 12) == 0x05) {
            if (Sub(CPtoDE_data.encodedInst, 31, 25) == 0) {
                return InstrType::INSTR_SRL;
            } else if (Sub(CPtoDE_data.encodedInst, 31, 25) == 32) {
                return InstrType::INSTR_SRA;
            } else {
                return InstrType::INSTR_UNKNOWN;
            }
        } else if (Sub(CPtoDE_data.encodedInst, 14, 12) == 0x06) {
            return InstrType::INSTR_OR;
        } else if (Sub(CPtoDE_data.encodedInst, 14, 12) == 0x07) {
            return InstrType::INSTR_AND;
        } else {
            return InstrType::INSTR_UNKNOWN;
        }
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x13) {
        if (Sub(CPtoDE_data.encodedInst, 14, 12) == 0x0) {
            return InstrType::INSTR_ADDI;
        } else if (Sub(CPtoDE_data.encodedInst, 14, 12) == 0x1) {
            return InstrType::INSTR_SLLI;
        } else if (Sub(CPtoDE_data.encodedInst, 14, 12) == 0x2) {
            return InstrType::INSTR_SLTI;
        } else if (Sub(CPtoDE_data.encodedInst, 14, 12) == 0x3) {
            return InstrType::INSTR_SLTUI;
        } else if (Sub(CPtoDE_data.encodedInst, 14, 12) == 0x4) {
            return InstrType::INSTR_XORI;
        } else if (Sub(CPtoDE_data.encodedInst, 14, 12) == 0x5) {
            if (Sub(CPtoDE_data.encodedInst, 31, 25) == 0) {
                return InstrType::INSTR_SRLI;
            } else if (Sub(CPtoDE_data.encodedInst, 31, 25) == 32) {
                return InstrType::INSTR_SRAI;
            } else {
                return InstrType::INSTR_UNKNOWN;
            }
        } else if (Sub(CPtoDE_data.encodedInst, 14, 12) == 0x6) {
            return InstrType::INSTR_ORI;
        } else if (Sub(CPtoDE_data.encodedInst, 14, 12) == 0x7) {
            return InstrType::INSTR_ANDI;
        } else {
            return InstrType::INSTR_UNKNOWN;
        }
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x03) {
        if (Sub(CPtoDE_data.encodedInst, 14, 12) == 0x0) {
            return InstrType::INSTR_LB;
        } else if (Sub(CPtoDE_data.encodedInst, 14, 12) == 0x01) {
            return InstrType::INSTR_LH;
        } else if (Sub(CPtoDE_data.encodedInst, 14, 12) == 0x02) {
            return InstrType::INSTR_LW;
        } else if (Sub(CPtoDE_data.encodedInst, 14, 12) == 0x04) {
            return InstrType::INSTR_LBU;
        } else if (Sub(CPtoDE_data.encodedInst, 14, 12) == 0x05) {
            return InstrType::INSTR_LHU;
        } else {
            return InstrType::INSTR_UNKNOWN;
        }
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x67) {
        return InstrType::INSTR_JALR;
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x23) {
        if (Sub(CPtoDE_data.encodedInst, 14, 12) == 0) {
            return InstrType::INSTR_SB;
        } else if (Sub(CPtoDE_data.encodedInst, 14, 12) == 1) {
            return InstrType::INSTR_SH;
        } else if (Sub(CPtoDE_data.encodedInst, 14, 12) == 2) {
            return InstrType::INSTR_SW;
        } else {
            return InstrType::INSTR_UNKNOWN;
        }
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x63) {
        if (Sub(CPtoDE_data.encodedInst, 14, 12) == 0x0) {
            return InstrType::INSTR_BEQ;
        } else if (Sub(CPtoDE_data.encodedInst, 14, 12) == 0x01) {
            return InstrType::INSTR_BNE;
        } else if (Sub(CPtoDE_data.encodedInst, 14, 12) == 0x04) {
            return InstrType::INSTR_BLT;
        } else if (Sub(CPtoDE_data.encodedInst, 14, 12) == 0x05) {
            return InstrType::INSTR_BGE;
        } else if (Sub(CPtoDE_data.encodedInst, 14, 12) == 0x06) {
            return InstrType::INSTR_BLTU;
        } else if (Sub(CPtoDE_data.encodedInst, 14, 12) == 0x07) {
            return InstrType::INSTR_BGEU;
        } else {
            return InstrType::INSTR_UNKNOWN;
        }
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x37) {
        return InstrType::INSTR_LUI;
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x17) {
        return InstrType::INSTR_AUIPC;
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x6F) {
        return InstrType::INSTR_JAL;
    } else {
        return InstrType::INSTR_UNKNOWN;
    }
}

RF_RD_AccessType Control_path::DE_reg_req_s2(CPtoDE_IF CPtoDE_data) const {

    if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x33) {
        return RF_RD;
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x13) {
        return RF_RD;
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x03) {
        return RF_RD;
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x67) {
        return RF_RD;
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x23) {
        return RF_RD;
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x63) {
        return RF_RD;
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x37) {
        return RF_RD_X;
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x17) {
        return RF_RD_X;
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x6F) {
        return RF_RD_X;
    } else {
        return RF_RD_X;
    }
}

unsigned int Control_path::DE_reg_rs1_addr_s2(CPtoDE_IF CPtoDE_data) const {

    if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x33) {
        return Sub(CPtoDE_data.encodedInst, RS1_MSB, RS1_LSB);
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x13) {
        return Sub(CPtoDE_data.encodedInst, RS1_MSB, RS1_LSB);
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x03) {
        return Sub(CPtoDE_data.encodedInst, RS1_MSB, RS1_LSB);
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x67) {
        return Sub(CPtoDE_data.encodedInst, RS1_MSB, RS1_LSB);
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x23) {
        return Sub(CPtoDE_data.encodedInst, RS1_MSB, RS1_LSB);
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x63) {
        return Sub(CPtoDE_data.encodedInst, RS1_MSB, RS1_LSB);
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x37) {
        return 0;
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x17) {
        return 0;
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x6F) {
        return 0;
    } else {
        return 0;
    }
}

unsigned int Control_path::DE_reg_rs2_addr_s2(CPtoDE_IF CPtoDE_data) const {

    if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x33) {
        return Sub(CPtoDE_data.encodedInst, RS2_MSB, RS2_LSB);
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x13) {
        return 0;
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x03) {
        return 0;
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x67) {
        return 0;
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x23) {
        return Sub(CPtoDE_data.encodedInst, RS2_MSB, RS2_LSB);
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x63) {
        return Sub(CPtoDE_data.encodedInst, RS2_MSB, RS2_LSB);
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x37) {
        return 0;
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x17) {
        return 0;
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x6F) {
        return 0;
    } else {
        return 0;
    }
}

unsigned int Control_path::DE_reg_rd_addr_s2(CPtoDE_IF CPtoDE_data) const {

    if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x33) {
        return Sub(CPtoDE_data.encodedInst, RD_MSB, RD_LSB);
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x13) {
        return Sub(CPtoDE_data.encodedInst, RD_MSB, RD_LSB);
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x03) {
        return Sub(CPtoDE_data.encodedInst, RD_MSB, RD_LSB);
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x67) {
        return Sub(CPtoDE_data.encodedInst, RD_MSB, RD_LSB);
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x23) {
        return 0;
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x63) {
        return 0;
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x37) {
        return Sub(CPtoDE_data.encodedInst, RD_MSB, RD_LSB);
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x17) {
        return Sub(CPtoDE_data.encodedInst, RD_MSB, RD_LSB);
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x6F) {
        return Sub(CPtoDE_data.encodedInst, RD_MSB, RD_LSB);
    } else {
        return 0;
    }
}

AL_FunctionType Control_path::DE_alu_fun_s3(CPtoDE_IF CPtoDE_data) const {

    if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x33) {
        if (Sub(CPtoDE_data.encodedInst, 14, 12) == 0x0) {
            if (Sub(CPtoDE_data.encodedInst, 31, 25) == 0) {
                return ALU_ADD;
            } else if (Sub(CPtoDE_data.encodedInst, 31, 25) == 32) {
                return ALU_SUB;
            } else {
                return ALU_X;
            }
        } else if (Sub(CPtoDE_data.encodedInst, 14, 12) == 0x01) {
            return ALU_SLL;
        } else if (Sub(CPtoDE_data.encodedInst, 14, 12) == 0x02) {
            return ALU_SLT;
        } else if (Sub(CPtoDE_data.encodedInst, 14, 12) == 0x03) {
            return ALU_SLTU;
        } else if (Sub(CPtoDE_data.encodedInst, 14, 12) == 0x04) {
            return ALU_XOR;
        } else if (Sub(CPtoDE_data.encodedInst, 14, 12) == 0x05) {
            if (Sub(CPtoDE_data.encodedInst, 31, 25) == 0) {
                return ALU_SRL;
            } else if (Sub(CPtoDE_data.encodedInst, 31, 25) == 32) {
                return ALU_SRA;
            } else {
                return ALU_X;
            }
        } else if (Sub(CPtoDE_data.encodedInst, 14, 12) == 0x06) {
            return ALU_OR;
        } else if (Sub(CPtoDE_data.encodedInst, 14, 12) == 0x07) {
            return ALU_AND;
        } else {
            return ALU_X;
        }
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x13) {
        if (Sub(CPtoDE_data.encodedInst, 14, 12) == 0x0) {
            return ALU_ADD;
        } else if (Sub(CPtoDE_data.encodedInst, 14, 12) == 0x1) {
            return ALU_SLL;
        } else if (Sub(CPtoDE_data.encodedInst, 14, 12) == 0x2) {
            return ALU_SLT;
        } else if (Sub(CPtoDE_data.encodedInst, 14, 12) == 0x3) {
            return ALU_SLTU;
        } else if (Sub(CPtoDE_data.encodedInst, 14, 12) == 0x4) {
            return ALU_XOR;
        } else if (Sub(CPtoDE_data.encodedInst, 14, 12) == 0x5) {
            if (Sub(CPtoDE_data.encodedInst, 31, 25) == 0) {
                return ALU_SRL;
            } else if (Sub(CPtoDE_data.encodedInst, 31, 25) == 32) {
                return ALU_SRA;
            } else {
                return ALU_X;
            }
        } else if (Sub(CPtoDE_data.encodedInst, 14, 12) == 0x6) {
            return ALU_OR;
        } else if (Sub(CPtoDE_data.encodedInst, 14, 12) == 0x7) {
            return ALU_AND;
        } else {
            return ALU_X;
        }
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x03) {
        return ALU_ADD;
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x67) {
        return ALU_X;
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x23) {
        return ALU_ADD;
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x63) {
        return ALU_X;
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x37) {
        return ALU_COPY1;
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x17) {
        return ALU_ADD;
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x6F) {
        return ALU_X;
    } else {
        return ALU_X;
    }
}

AL_OperandSelType Control_path::DE_alu_op1_sel_s3(CPtoDE_IF CPtoDE_data) const {

    if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x33) {
        return OP_REG;
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x13) {
        return OP_REG;
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x03) {
        return OP_REG;
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x67) {
        return OP_X;
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x23) {
        return OP_REG;
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x63) {
        return OP_X;
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x37) {
        return OP_IMM;
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x17) {
        return OP_PC;
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x6F) {
        return OP_X;
    } else {
        return OP_X;
    }
}

AL_OperandSelType Control_path::DE_alu_op2_sel_s3(CPtoDE_IF CPtoDE_data) const {

    if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x33) {
        return OP_REG;
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x13) {
        return OP_IMM;
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x03) {
        return OP_IMM;
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x67) {
        return OP_X;
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x23) {
        return OP_IMM;
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x63) {
        return OP_X;
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x37) {
        return OP_X;
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x17) {
        return OP_IMM;
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x6F) {
        return OP_X;
    } else {
        return OP_X;
    }
}

unsigned int Control_path::DE_imm_s3(CPtoDE_IF CPtoDE_data) const {

    if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x33) {
        return 0;
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x13) {
        if (Sub(CPtoDE_data.encodedInst, 14, 12) == 0x1 || Sub(CPtoDE_data.encodedInst, 14, 12) == 0x5) {
            return Sub(CPtoDE_data.encodedInst, 24, 20);
        } else if (Sub(Sub(CPtoDE_data.encodedInst, 31, 20), 11, 11) == 1) {
            return Cat(Fill(20), 20, Sub(CPtoDE_data.encodedInst, 31, 20), 12);
        } else {
            return Sub(CPtoDE_data.encodedInst, 31, 20);
        }
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x03) {
        if (Sub(CPtoDE_data.encodedInst, 31, 31) == 1) {
            return Cat(Fill(20), 20, Sub(CPtoDE_data.encodedInst, 31, 20), 12);
        } else {
            return Sub(CPtoDE_data.encodedInst, 31, 20);
        }
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x67) {
        return 0;
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x23) {
        if (Sub(CPtoDE_data.encodedInst, 31, 31) == 1) {
            return Cat(Fill(20), 20, Cat(Sub(CPtoDE_data.encodedInst, 31, 25), 7, Sub(CPtoDE_data.encodedInst, 11, 7), 5), 12);
        } else {
            return Cat(Sub(CPtoDE_data.encodedInst, 31, 25), 7, Sub(CPtoDE_data.encodedInst, 11, 7), 5);
        }
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x63) {
        return 0;
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x37) {
        return Cat(Sub(CPtoDE_data.encodedInst, 31, 12), 20, 0, 12);
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x17) {
        return Cat(Sub(CPtoDE_data.encodedInst, 31, 12), 20, 0, 12);
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x6F) {
        return 0;
    } else {
        return 0;
    }
}

ME_AccessType Control_path::DE_dmem_req_s4(CPtoDE_IF CPtoDE_data) const {

    if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x33) {
        return ME_X;
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x13) {
        return ME_X;
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x03) {
        return ME_RD;
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x67) {
        return ME_X;
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x23) {
        return ME_WR;
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x63) {
        return ME_X;
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x37) {
        return ME_X;
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x17) {
        return ME_X;
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x6F) {
        return ME_X;
    } else {
        return ME_X;
    }
}

ME_MaskType Control_path::DE_dmem_mask_s4(CPtoDE_IF CPtoDE_data) const {

    if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x33) {
        return MT_X;
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x13) {
        return MT_X;
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x03) {
        if (Sub(CPtoDE_data.encodedInst, 14, 12) == 0x0) {
            return MT_B;
        } else if (Sub(CPtoDE_data.encodedInst, 14, 12) == 0x01) {
            return MT_H;
        } else if (Sub(CPtoDE_data.encodedInst, 14, 12) == 0x02) {
            return MT_W;
        } else if (Sub(CPtoDE_data.encodedInst, 14, 12) == 0x04) {
            return MT_BU;
        } else if (Sub(CPtoDE_data.encodedInst, 14, 12) == 0x05) {
            return MT_HU;
        } else {
            return MT_X;
        }
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x67) {
        return MT_X;
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x23) {
        if (Sub(CPtoDE_data.encodedInst, 14, 12) == 0) {
            return MT_B;
        } else if (Sub(CPtoDE_data.encodedInst, 14, 12) == 1) {
            return MT_H;
        } else if (Sub(CPtoDE_data.encodedInst, 14, 12) == 2) {
            return MT_W;
        } else {
            return MT_X;
        }
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x63) {
        return MT_X;
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x37) {
        return MT_X;
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x17) {
        return MT_X;
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x6F) {
        return MT_X;
    } else {
        return MT_X;
    }
}

RF_WR_AccessType Control_path::DE_reg_req_s5(CPtoDE_IF CPtoDE_data) const {

    if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x33) {
        return RF_WR;
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x13) {
        return RF_WR;
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x03) {
        return RF_WR;
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x67) {
        return RF_WR;
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x23) {
        return RF_WR_X;
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x63) {
        return RF_WR_X;
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x37) {
        return RF_WR;
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x17) {
        return RF_WR;
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x6F) {
        return RF_WR;
    } else {
        return RF_WR_X;
    }
}

RF_WriteDataSelType Control_path::DE_reg_write_data_sel_s5(CPtoDE_IF CPtoDE_data) const {

    if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x33) {
        return WB_ALU;
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x13) {
        return WB_ALU;
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x03) {
        return WB_MEM;
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x67) {
        return WB_PC4;
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x23) {
        return WB_X;
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x63) {
        return WB_X;
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x37) {
        return WB_ALU;
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x17) {
        return WB_ALU;
    } else if (Sub(CPtoDE_data.encodedInst, 6, 0) == 0x6F) {
        return WB_PC4;
    } else {
        return WB_X;
    }
}

#endif //PROJECT_CONTROL_PATH_H