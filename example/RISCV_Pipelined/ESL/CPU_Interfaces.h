#ifndef PROJECT_CPU_INTERFACES_H
#define PROJECT_CPU_INTERFACES_H

#include "../../RISCV_commons/Memory_Interfaces.h"
#include "../../RISCV_commons/Utilities.h"


enum EncType {
    ENC_R, ENC_I_I, ENC_I_L, ENC_I_J, ENC_S, ENC_B, ENC_U, ENC_J, ENC_ERR
};

enum RF_RD_AccessType{
    RF_RD_X, RF_RD
};

enum RF_WR_AccessType{
    RF_WR_X, RF_WR
};

enum RF_WriteDataSelType {
    WB_X, WB_ALU, WB_MEM, WB_PC4
};

enum AL_FunctionType {
    ALU_X, ALU_ADD, ALU_SUB, ALU_SLL, ALU_SRL, ALU_SRA, ALU_AND, ALU_OR, ALU_XOR, ALU_SLT, ALU_SLTU, ALU_COPY1
};

enum AL_OperandSelType {
    OP_X, OP_REG, OP_IMM, OP_PC
};

enum PC_SelType {
    PC_4, PC_BR, PC_J, PC_JR//, PC_EXC
};

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

struct CP_IF {
    bool prev_memory_access;

    EncType encType_s5; //++++++++++++++++++++++++++
    unsigned int reg_rd_addr_s5; //++++++++++++++++++++++++++
    InstrType instType_s5; // for debugging

    EncType encType_s4; //++++++++++++++++++++++++++
    unsigned int reg_rd_addr_s4; //++++++++++++++++++++++++++
    InstrType instType_s4; // for debugging

    InstrType instType_s2;
    InstrType instType_s3;

    PC_SelType pc_sel;
    unsigned int pc_imm;

    unsigned int reg1_content;

    bool /*prevInst_B,*/ prevInst_JR, flush, dmem_access, flush_dmem_access/*, getOldPCvalues*/;

    bool stall_once, stall_twice;

    bool dmem_access_s5;
};

struct CPtoDE_IF {

    unsigned int encodedInst;
};

struct DEtoCP_IF {

    PC_SelType pc_sel_s2;
    unsigned int imm_s2;

    EncType enc_type_s2;
    InstrType inst_type_s2;

    RF_RD_AccessType reg_req_s2;
    unsigned int reg_rs1_addr_s2;
    unsigned int reg_rs2_addr_s2;
    unsigned int reg_rd_addr_s2;

    AL_FunctionType alu_fun_s3;
    AL_OperandSelType alu_op1_sel_s3, alu_op2_sel_s3;
    unsigned int imm_s3;

    ME_AccessType dmem_req_s4;
    ME_MaskType dmem_mask_s4;

    RF_WR_AccessType reg_req_s5;
    RF_WriteDataSelType reg_write_data_sel_s5;
};

struct CPtoDP_IF {

    bool prev_memory_access;

    /*bool flush_branch;*/

    unsigned int pc_s2;

    EncType enc_type_s2;
    InstrType inst_type_s2; // for debugging

    RF_RD_AccessType reg_req_s2;
    unsigned int reg_rs1_addr_s2;
    unsigned int reg_rs2_addr_s2;
    unsigned int reg_rd_addr_s2;

    AL_FunctionType alu_fun_s3;
    AL_OperandSelType alu_op1_sel_s3, alu_op2_sel_s3;
    unsigned int imm_s3;

    ME_AccessType dmem_req_s4;
    ME_MaskType dmem_mask_s4;

    bool stall_dmem_access_s4;

    RF_WR_AccessType reg_req_s5;
    RF_WriteDataSelType reg_write_data_sel_s5;

    unsigned int loadedData_s5;
};

struct CPtoDP_S3_IF {

    AL_FunctionType alu_fun_s3;
    AL_OperandSelType alu_op1_sel_s3, alu_op2_sel_s3;
    unsigned int imm_s3;
};

struct CPtoDP_S4_IF {

    ME_AccessType dmem_req_s4;
    ME_MaskType dmem_mask_s4;
};

struct CPtoDP_S5_IF {

    RF_WR_AccessType reg_req_s5;
    RF_WriteDataSelType reg_write_data_sel_s5;
};

struct DPtoCP_IF {

    unsigned int reg1_content;
    unsigned int reg2_content;

    ME_AccessType req;
    ME_MaskType mask;
    unsigned int addrIn; //FIXME: Changed from unsigned int
    unsigned int dataIn;
};

struct CPtoPC_IF {

    bool stall;

    PC_SelType pc_sel_s2;
    unsigned int imm_s2;

    bool branchTaken;
    unsigned int reg1_content;
};

struct PCtoCP_IF {

    unsigned int pc;
};

struct DP_S3_IF {

    unsigned int pc_s3;
    EncType enc_type_s3;
    InstrType inst_type_s3; // for debugging
    unsigned int reg_rs1_addr_s3;
    unsigned int reg_rs2_addr_s3;
    unsigned int reg_rd_addr_s3;
    unsigned int reg1_content_s3;
    unsigned int reg2_content_s3;
};

struct DP_S4_IF {

    bool prev_memory_access;
    unsigned int prev_loadedData;

    unsigned int pc_s4;
    EncType enc_type_s4;
    InstrType inst_type_s4; // for debugging
    unsigned int reg_rs2_addr_s4;
    unsigned int reg_rd_addr_s4;
    unsigned int reg2_content_s4;
    unsigned int alu_result_s4;
};

struct DP_S5_IF {

    unsigned int pc_s5;
    EncType enc_type_s5;
    InstrType inst_type_s5; // for debugging
    unsigned int reg_rd_addr_s5;
    unsigned int alu_result_s5;
};

struct DPtoRF_IF {

    RF_WR_AccessType wrReq;
    unsigned int dst;
    unsigned int dstData;
};

struct RFtoDP_IF {

    unsigned int reg_file_01;
    unsigned int reg_file_02;
    unsigned int reg_file_03;
    unsigned int reg_file_04;
    unsigned int reg_file_05;
    unsigned int reg_file_06;
    unsigned int reg_file_07;
    unsigned int reg_file_08;
    unsigned int reg_file_09;
    unsigned int reg_file_10;
    unsigned int reg_file_11;
    unsigned int reg_file_12;
    unsigned int reg_file_13;
    unsigned int reg_file_14;
    unsigned int reg_file_15;
    unsigned int reg_file_16;
    unsigned int reg_file_17;
    unsigned int reg_file_18;
    unsigned int reg_file_19;
    unsigned int reg_file_20;
    unsigned int reg_file_21;
    unsigned int reg_file_22;
    unsigned int reg_file_23;
    unsigned int reg_file_24;
    unsigned int reg_file_25;
    unsigned int reg_file_26;
    unsigned int reg_file_27;
    unsigned int reg_file_28;
    unsigned int reg_file_29;
    unsigned int reg_file_30;
    unsigned int reg_file_31;
};

struct DPtoAL_IF {

    AL_FunctionType alu_fun;
    unsigned int alu_op1;
    unsigned int alu_op2;
};

/*struct ALtoDP_IF {

    unsigned int alu_result;
};*/

#endif // PROJECT_CPU_INTERFACES_H