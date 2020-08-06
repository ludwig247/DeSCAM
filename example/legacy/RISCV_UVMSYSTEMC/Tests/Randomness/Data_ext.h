//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 10/24/18.
//

#ifndef UVMSYSTEMC_DATA_EXT_H
#define UVMSYSTEMC_DATA_EXT_H

#include "scv.h"
#include "../../Golden_Reference/GOLDEN_CPU_Interfaces.h"

template<>
class scv_extensions<G_PrivInstrType> : public scv_enum_base<G_PrivInstrType> {
public:
    SCV_ENUM_CTOR(G_PrivInstrType) {
        SCV_ENUM(G_INSTR_PRIV_UNKNOWN);
        SCV_ENUM(G_INSTR_ECALL);
        SCV_ENUM(G_INSTR_EBREAK);
        SCV_ENUM(G_INSTR_MRET);
    }
};

template<>
class scv_extensions<G_InstrType> : public scv_enum_base<G_InstrType> {
public:
    SCV_ENUM_CTOR(G_InstrType) {
        SCV_ENUM(G_INSTR_UNKNOWN);
        SCV_ENUM(G_INSTR_LUI);
        SCV_ENUM(G_INSTR_AUIPC);
        SCV_ENUM(G_INSTR_JAL);
        SCV_ENUM(G_INSTR_JALR);
        SCV_ENUM(G_INSTR_BEQ);
        SCV_ENUM(G_INSTR_BNE);
        SCV_ENUM(G_INSTR_BLT);
        SCV_ENUM(G_INSTR_BGE);
        SCV_ENUM(G_INSTR_BLTU);
        SCV_ENUM(G_INSTR_BGEU);
        SCV_ENUM(G_INSTR_LB);
        SCV_ENUM(G_INSTR_LH);
        SCV_ENUM(G_INSTR_LW);
        SCV_ENUM(G_INSTR_LBU);
        SCV_ENUM(G_INSTR_LHU);
        SCV_ENUM(G_INSTR_SB);
        SCV_ENUM(G_INSTR_SH);
        SCV_ENUM(G_INSTR_SW);
        SCV_ENUM(G_INSTR_ADDI);
        SCV_ENUM(G_INSTR_SLTI);
        SCV_ENUM(G_INSTR_SLTUI);
        SCV_ENUM(G_INSTR_XORI);
        SCV_ENUM(G_INSTR_ORI);
        SCV_ENUM(G_INSTR_ANDI);
        SCV_ENUM(G_INSTR_SLLI);
        SCV_ENUM(G_INSTR_SRLI);
        SCV_ENUM(G_INSTR_SRAI);
        SCV_ENUM(G_INSTR_ADD);
        SCV_ENUM(G_INSTR_SUB);
        SCV_ENUM(G_INSTR_SLL);
        SCV_ENUM(G_INSTR_SLT);
        SCV_ENUM(G_INSTR_SLTU);
        SCV_ENUM(G_INSTR_XOR);
        SCV_ENUM(G_INSTR_SRL);
        SCV_ENUM(G_INSTR_SRA);
        SCV_ENUM(G_INSTR_OR);
        SCV_ENUM(G_INSTR_AND);
        SCV_ENUM(G_INSTR_FENCE);
        SCV_ENUM(G_INSTR_FENCEI);
        SCV_ENUM(G_INSTR_PRIV);
        SCV_ENUM(G_INSTR_CSRRW);
        SCV_ENUM(G_INSTR_CSRRS);
        SCV_ENUM(G_INSTR_CSRRC);
        SCV_ENUM(G_INSTR_CSRRWI);
        SCV_ENUM(G_INSTR_CSRRSI);
        SCV_ENUM(G_INSTR_CSRRCI);
    }
};


template<>
class scv_extensions<G_EncType> : public scv_enum_base<G_EncType> {
public:
    SCV_ENUM_CTOR(G_EncType) {
        SCV_ENUM(G_ENC_R);
        SCV_ENUM(G_ENC_I_I);
        SCV_ENUM(G_ENC_I_L);
        SCV_ENUM(G_ENC_I_J);
        SCV_ENUM(G_ENC_I_M);
        SCV_ENUM(G_ENC_I_S);
        SCV_ENUM(G_ENC_S);
        SCV_ENUM(G_ENC_B);
        SCV_ENUM(G_ENC_U);
        SCV_ENUM(G_ENC_J);
        SCV_ENUM(G_ENC_ERR);
    }
};


template<>
class scv_extensions<G_ALUfuncType> : public scv_enum_base<G_ALUfuncType> {
public:
    SCV_ENUM_CTOR(G_ALUfuncType) {
        SCV_ENUM(G_ALU_X);
        SCV_ENUM(G_ALU_ADD);
        SCV_ENUM(G_ALU_SUB);
        SCV_ENUM(G_ALU_SLL);
        SCV_ENUM(G_ALU_SRL);
        SCV_ENUM(G_ALU_SRA);
        SCV_ENUM(G_ALU_AND);
        SCV_ENUM(G_ALU_OR);
        SCV_ENUM(G_ALU_XOR);
        SCV_ENUM(G_ALU_SLT);
        SCV_ENUM(G_ALU_SLTU);
        SCV_ENUM(G_ALU_COPY1);
    }
};


template<>
class scv_extensions<G_RegfileWriteType> : public scv_extensions_base<G_RegfileWriteType> {
public:
    scv_extensions<unsigned int> G_dst;
    scv_extensions<unsigned int> G_dstData;

    SCV_EXTENSIONS_CTOR(G_RegfileWriteType) {
        //must be in order
        SCV_FIELD(G_dst);
        SCV_FIELD(G_dstData);
    }
};


template<>
class scv_extensions<G_RegfileType> : public scv_extensions_base<G_RegfileType> {
public:
    scv_extensions<unsigned int> G_reg_file_01;
    scv_extensions<unsigned int> G_reg_file_02;
    scv_extensions<unsigned int> G_reg_file_03;
    scv_extensions<unsigned int> G_reg_file_04;
    scv_extensions<unsigned int> G_reg_file_05;
    scv_extensions<unsigned int> G_reg_file_06;
    scv_extensions<unsigned int> G_reg_file_07;
    scv_extensions<unsigned int> G_reg_file_08;
    scv_extensions<unsigned int> G_reg_file_09;
    scv_extensions<unsigned int> G_reg_file_10;
    scv_extensions<unsigned int> G_reg_file_11;
    scv_extensions<unsigned int> G_reg_file_12;
    scv_extensions<unsigned int> G_reg_file_13;
    scv_extensions<unsigned int> G_reg_file_14;
    scv_extensions<unsigned int> G_reg_file_15;
    scv_extensions<unsigned int> G_reg_file_16;
    scv_extensions<unsigned int> G_reg_file_17;
    scv_extensions<unsigned int> G_reg_file_18;
    scv_extensions<unsigned int> G_reg_file_19;
    scv_extensions<unsigned int> G_reg_file_20;
    scv_extensions<unsigned int> G_reg_file_21;
    scv_extensions<unsigned int> G_reg_file_22;
    scv_extensions<unsigned int> G_reg_file_23;
    scv_extensions<unsigned int> G_reg_file_24;
    scv_extensions<unsigned int> G_reg_file_25;
    scv_extensions<unsigned int> G_reg_file_26;
    scv_extensions<unsigned int> G_reg_file_27;
    scv_extensions<unsigned int> G_reg_file_28;
    scv_extensions<unsigned int> G_reg_file_29;
    scv_extensions<unsigned int> G_reg_file_30;
    scv_extensions<unsigned int> G_reg_file_31;

    SCV_EXTENSIONS_CTOR(G_RegfileType) {
        //must be in order
        SCV_FIELD(G_reg_file_01);
        SCV_FIELD(G_reg_file_02);
        SCV_FIELD(G_reg_file_03);
        SCV_FIELD(G_reg_file_04);
        SCV_FIELD(G_reg_file_05);
        SCV_FIELD(G_reg_file_06);
        SCV_FIELD(G_reg_file_07);
        SCV_FIELD(G_reg_file_08);
        SCV_FIELD(G_reg_file_09);
        SCV_FIELD(G_reg_file_10);
        SCV_FIELD(G_reg_file_11);
        SCV_FIELD(G_reg_file_12);
        SCV_FIELD(G_reg_file_13);
        SCV_FIELD(G_reg_file_14);
        SCV_FIELD(G_reg_file_15);
        SCV_FIELD(G_reg_file_16);
        SCV_FIELD(G_reg_file_17);
        SCV_FIELD(G_reg_file_18);
        SCV_FIELD(G_reg_file_19);
        SCV_FIELD(G_reg_file_20);
        SCV_FIELD(G_reg_file_21);
        SCV_FIELD(G_reg_file_22);
        SCV_FIELD(G_reg_file_23);
        SCV_FIELD(G_reg_file_24);
        SCV_FIELD(G_reg_file_25);
        SCV_FIELD(G_reg_file_26);
        SCV_FIELD(G_reg_file_27);
        SCV_FIELD(G_reg_file_28);
        SCV_FIELD(G_reg_file_29);
        SCV_FIELD(G_reg_file_30);
        SCV_FIELD(G_reg_file_31);
    }
};



template<>
class scv_extensions<G_RegfileSyscallType> : public scv_extensions_base<G_RegfileSyscallType> {
public:
    scv_extensions<unsigned int> G_reg_file_10;
    scv_extensions<unsigned int> G_reg_file_11;
    scv_extensions<unsigned int> G_reg_file_12;
    scv_extensions<unsigned int> G_reg_file_17;

    SCV_EXTENSIONS_CTOR(G_RegfileSyscallType) {
            //must be in order
            SCV_FIELD(G_reg_file_10);
            SCV_FIELD(G_reg_file_11);
            SCV_FIELD(G_reg_file_12);
            SCV_FIELD(G_reg_file_17);
    }
};


template<>
class scv_extensions<G_CSRfileType> : public scv_extensions_base<G_CSRfileType> {
public:
    scv_extensions<unsigned int> G_mstatus;
    scv_extensions<unsigned int> G_mie;
    scv_extensions<unsigned int> G_mtvec;
    scv_extensions<unsigned int> G_mepc;
    scv_extensions<unsigned int> G_mcause;
    scv_extensions<unsigned int> G_mip;

    SCV_EXTENSIONS_CTOR(G_CSRfileType) {
            //must be in order
            SCV_FIELD(G_mstatus);
            SCV_FIELD(G_mie);
            SCV_FIELD(G_mtvec);
            SCV_FIELD(G_mepc);
            SCV_FIELD(G_mcause);
            SCV_FIELD(G_mip);
    }
};


template<>
class scv_extensions<G_DecodedInstr> : public scv_extensions_base<G_DecodedInstr> {
public:
    scv_extensions<G_EncType> G_encType;
    scv_extensions<G_InstrType> G_instrType;
    scv_extensions<G_PrivInstrType> G_privInstrType;
    scv_extensions<unsigned int> G_rd_addr;
    scv_extensions<unsigned int> G_rs1_addr;
    scv_extensions<unsigned int> G_rs2_addr;
    scv_extensions<unsigned int> G_imm;

    SCV_EXTENSIONS_CTOR(G_DecodedInstr) {
            //must be in order
            SCV_FIELD(G_encType);
            SCV_FIELD(G_instrType);
            SCV_FIELD(G_privInstrType);
            SCV_FIELD(G_rd_addr);
            SCV_FIELD(G_rs1_addr);
            SCV_FIELD(G_rs2_addr);
            SCV_FIELD(G_imm);
    }
};
#endif //UVMSYSTEMC_DATA_EXT_H
