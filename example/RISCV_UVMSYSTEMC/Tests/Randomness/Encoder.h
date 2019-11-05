//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 10/24/18.
//

#ifndef UVMSYSTEMC_ENCODER_H
#define UVMSYSTEMC_ENCODER_H


#include "../../Golden_Reference/GOLDEN_CPU_Interfaces.h"

unsigned int encode_instruction(G_DecodedInstr decodedinstr) {

    unsigned int encodedInstr;

    unsigned int _rd = decodedinstr.G_rd_addr << 7;
    unsigned int _rs1 = decodedinstr.G_rs1_addr << 15;
    unsigned int _rs2 = decodedinstr.G_rs2_addr << 20;
    unsigned int _opcode = 0;
    unsigned int _funct3 = 0;
    unsigned int _funct7 = 0;
    unsigned int _imm = 0;

    /// position the immediate
    if (decodedinstr.G_encType == G_EncType::G_ENC_R) {
        _imm = 0;
    } else if (decodedinstr.G_encType == G_EncType::G_ENC_I_I || decodedinstr.G_encType == G_EncType::G_ENC_I_M ||
               decodedinstr.G_encType == G_EncType::G_ENC_I_J || decodedinstr.G_encType == G_EncType::G_ENC_I_L ||
               decodedinstr.G_encType == G_EncType::G_ENC_I_S) {
        _imm = (decodedinstr.G_imm & 0x00000FFF) << 20;
    } else if (decodedinstr.G_encType == G_EncType::G_ENC_S) {
        unsigned int imm_1 = (decodedinstr.G_imm & 0x0000001F) << 7;
        unsigned int imm_2 = (decodedinstr.G_imm & 0x00000FE0) << 25;
        _imm = imm_2 | imm_1;
    } else if (decodedinstr.G_encType == G_EncType::G_ENC_B) {
        unsigned int imm_1 = (decodedinstr.G_imm & 0x00000800) << 7;
        unsigned int imm_2 = (decodedinstr.G_imm & 0x0000001E) << 8;
        unsigned int imm_3 = (decodedinstr.G_imm & 0x000007E0) << 25;
        unsigned int imm_4 = (decodedinstr.G_imm & 0x00001000) << 31;
        _imm = imm_4 | imm_3 | imm_2 | imm_1;
    } else if (decodedinstr.G_encType == G_EncType::G_ENC_U) {
        _imm = (decodedinstr.G_imm & 0xFFFFF000) << 0;
    } else if (decodedinstr.G_encType == G_EncType::G_ENC_J) {
        unsigned int imm_1 = (decodedinstr.G_imm & 0x000FF000) << 12;
        unsigned int imm_2 = (decodedinstr.G_imm & 0x00000800) << 20;
        unsigned int imm_3 = (decodedinstr.G_imm & 0x000007FE) << 21;
        unsigned int imm_4 = (decodedinstr.G_imm & 0x00100000) << 31;
        _imm = imm_4 | imm_3 | imm_2 | imm_1;
    } else { //G_EncType::Error_Type
        _imm = 0;
    }

    /// calculate the opcode, func3, func7 and create the encoded instruction
    if (decodedinstr.G_instrType == G_InstrType::G_INSTR_LUI) {
        _opcode = 0x37;
        encodedInstr = _imm | _rd | _opcode;
    } else if (decodedinstr.G_instrType == G_InstrType::G_INSTR_AUIPC) {
        _opcode = 0x17;
        encodedInstr = _imm | _rd | _opcode;
    } else if (decodedinstr.G_instrType == G_InstrType::G_INSTR_JAL) {
        _opcode = 0x6F;
        encodedInstr = _imm | _rd | _opcode;
    } else if (decodedinstr.G_instrType == G_InstrType::G_INSTR_JALR) {
        _opcode = 0x67;
        _funct3 = 0x0 << 12;
        encodedInstr = _imm | _rs1 | _funct3 | _rd | _opcode;
    } else if (decodedinstr.G_instrType == G_InstrType::G_INSTR_BEQ) {
        _opcode = 0x63;
        _funct3 = 0x0 << 12;
        encodedInstr = _imm | _rs2 | _rs1 | _funct3 | _opcode;
    } else if (decodedinstr.G_instrType == G_InstrType::G_INSTR_BNE) {
        _opcode = 0x63;
        _funct3 = 0x1 << 12;
        encodedInstr = _imm | _rs2 | _rs1 | _funct3 | _opcode;
    } else if (decodedinstr.G_instrType == G_InstrType::G_INSTR_BLT) {
        _opcode = 0x63;
        _funct3 = 0x4 << 12;
        encodedInstr = _imm | _rs2 | _rs1 | _funct3 | _opcode;
    } else if (decodedinstr.G_instrType == G_InstrType::G_INSTR_BGE) {
        _opcode = 0x63;
        _funct3 = 0x5 << 12;
        encodedInstr = _imm | _rs2 | _rs1 | _funct3 | _opcode;
    } else if (decodedinstr.G_instrType == G_InstrType::G_INSTR_BLTU) {
        _opcode = 0x63;
        _funct3 = 0x6 << 12;
        encodedInstr = _imm | _rs2 | _rs1 | _funct3 | _opcode;
    } else if (decodedinstr.G_instrType == G_InstrType::G_INSTR_BGEU) {
        _opcode = 0x63;
        _funct3 = 0x7 << 12;
        encodedInstr = _imm | _rs2 | _rs1 | _funct3 | _opcode;
    } else if (decodedinstr.G_instrType == G_InstrType::G_INSTR_LB) {
        _opcode = 0x03;
        _funct3 = 0x0 << 12;
        encodedInstr = _imm | _rs1 | _funct3 | _rd | _opcode;
    } else if (decodedinstr.G_instrType == G_InstrType::G_INSTR_LH) {
        _opcode = 0x03;
        _funct3 = 0x1 << 12;
        encodedInstr = _imm | _rs1 | _funct3 | _rd | _opcode;
    } else if (decodedinstr.G_instrType == G_InstrType::G_INSTR_LW) {
        _opcode = 0x03;
        _funct3 = 0x2 << 12;
        encodedInstr = _imm | _rs1 | _funct3 | _rd | _opcode;
    } else if (decodedinstr.G_instrType == G_InstrType::G_INSTR_LBU) {
        _opcode = 0x03;
        _funct3 = 0x4 << 12;
        encodedInstr = _imm | _rs1 | _funct3 | _rd | _opcode;
    } else if (decodedinstr.G_instrType == G_InstrType::G_INSTR_LHU) {
        _opcode = 0x03;
        _funct3 = 0x5 << 12;
        encodedInstr = _imm | _rs1 | _funct3 | _rd | _opcode;
    } else if (decodedinstr.G_instrType == G_InstrType::G_INSTR_SB) {
        _opcode = 0x23;
        _funct3 = 0x0 << 12;
        encodedInstr = _imm | _rs2 | _rs1 | _funct3 | _opcode;
    } else if (decodedinstr.G_instrType == G_InstrType::G_INSTR_SH) {
        _opcode = 0x23;
        _funct3 = 0x1 << 12;
        encodedInstr = _imm | _rs2 | _rs1 | _funct3 | _opcode;
    } else if (decodedinstr.G_instrType == G_InstrType::G_INSTR_SW) {
        _opcode = 0x23;
        _funct3 = 0x2 << 12;
        encodedInstr = _imm | _rs2 | _rs1 | _funct3 | _opcode;
    } else if (decodedinstr.G_instrType == G_InstrType::G_INSTR_ADDI) {
        _opcode = 0x13;
        _funct3 = 0x0 << 12;
        encodedInstr = _imm | _rs1 | _funct3 | _rd | _opcode;
    } else if (decodedinstr.G_instrType == G_InstrType::G_INSTR_SLTI) {
        _opcode = 0x13;
        _funct3 = 0x2 << 12;
        encodedInstr = _imm | _rs1 | _funct3 | _rd | _opcode;
    } else if (decodedinstr.G_instrType == G_InstrType::G_INSTR_SLTUI) {
        _opcode = 0x13;
        _funct3 = 0x3 << 12;
        encodedInstr = _imm | _rs1 | _funct3 | _rd | _opcode;
    } else if (decodedinstr.G_instrType == G_InstrType::G_INSTR_XORI) {
        _opcode = 0x13;
        _funct3 = 0x4 << 12;
        encodedInstr = _imm | _rs1 | _funct3 | _rd | _opcode;
    } else if (decodedinstr.G_instrType == G_InstrType::G_INSTR_ORI) {
        _opcode = 0x13;
        _funct3 = 0x6 << 12;
        encodedInstr = _imm | _rs1 | _funct3 | _rd | _opcode;
    } else if (decodedinstr.G_instrType == G_InstrType::G_INSTR_ANDI) {
        _opcode = 0x13;
        _funct3 = 0x7 << 12;
        encodedInstr = _imm | _rs1 | _funct3 | _rd | _opcode;
    } else if (decodedinstr.G_instrType == G_InstrType::G_INSTR_SLLI) {
        _opcode = 0x13;
        _funct3 = 0x1 << 12;
        _imm = _imm & 0x01FFFFFF;
        encodedInstr = _imm | _rs1 | _funct3 | _rd | _opcode;
    } else if (decodedinstr.G_instrType == G_InstrType::G_INSTR_SRLI) {
        _opcode = 0x13;
        _funct3 = 0x5 << 12;
        _imm = _imm & 0x01FFFFFF;
        encodedInstr = _imm | _rs1 | _funct3 | _rd | _opcode;
    } else if (decodedinstr.G_instrType == G_InstrType::G_INSTR_SRAI) {
        _opcode = 0x13;
        _funct3 = 0x1 << 12;
        _imm = (_imm & 0x01FFFFFF) | 0x40000000;
        encodedInstr = _imm | _rs1 | _funct3 | _rd | _opcode;
    } else if (decodedinstr.G_instrType == G_InstrType::G_INSTR_ADD) {
        _opcode = 0x33;
        _funct3 = 0x0 << 12;
        _funct7 = 0x00 << 25;
        encodedInstr = _funct7 | _rs2 | _rs1 | _funct3 | _rd | _opcode;
    } else if (decodedinstr.G_instrType == G_InstrType::G_INSTR_SUB) {
        _opcode = 0x33;
        _funct3 = 0x0 << 12;
        _funct7 = 0x20 << 25;
        encodedInstr = _funct7 | _rs2 | _rs1 | _funct3 | _rd | _opcode;
    } else if (decodedinstr.G_instrType == G_InstrType::G_INSTR_SLL) {
        _opcode = 0x33;
        _funct3 = 0x1 << 12;
        _funct7 = 0x00 << 25;
        encodedInstr = _funct7 | _rs2 | _rs1 | _funct3 | _rd | _opcode;
    } else if (decodedinstr.G_instrType == G_InstrType::G_INSTR_SLT) {
        _opcode = 0x33;
        _funct3 = 0x2 << 12;
        _funct7 = 0x00 << 25;
        encodedInstr = _funct7 | _rs2 | _rs1 | _funct3 | _rd | _opcode;
    } else if (decodedinstr.G_instrType == G_InstrType::G_INSTR_SLTU) {
        _opcode = 0x33;
        _funct3 = 0x3 << 12;
        _funct7 = 0x00 << 25;
        encodedInstr = _funct7 | _rs2 | _rs1 | _funct3 | _rd | _opcode;
    } else if (decodedinstr.G_instrType == G_InstrType::G_INSTR_XOR) {
        _opcode = 0x33;
        _funct3 = 0x4 << 12;
        _funct7 = 0x00 << 25;
        encodedInstr = _funct7 | _rs2 | _rs1 | _funct3 | _rd | _opcode;
    } else if (decodedinstr.G_instrType == G_InstrType::G_INSTR_SRL) {
        _opcode = 0x33;
        _funct3 = 0x5 << 12;
        _funct7 = 0x00 << 25;
        encodedInstr = _funct7 | _rs2 | _rs1 | _funct3 | _rd | _opcode;
    } else if (decodedinstr.G_instrType == G_InstrType::G_INSTR_SRA) {
        _opcode = 0x33;
        _funct3 = 0x5 << 12;
        _funct7 = 0x20 << 25;
        encodedInstr = _funct7 | _rs2 | _rs1 | _funct3 | _rd | _opcode;
    } else if (decodedinstr.G_instrType == G_InstrType::G_INSTR_OR) {
        _opcode = 0x33;
        _funct3 = 0x6 << 12;
        _funct7 = 0x00 << 25;
        encodedInstr = _funct7 | _rs2 | _rs1 | _funct3 | _rd | _opcode;
    } else if (decodedinstr.G_instrType == G_InstrType::G_INSTR_AND) {
        _opcode = 0x33;
        _funct3 = 0x7 << 12;
        _funct7 = 0x00 << 25;
        encodedInstr = _funct7 | _rs2 | _rs1 | _funct3 | _rd | _opcode;
    } else if (decodedinstr.G_instrType == G_InstrType::G_INSTR_FENCE) {
        _opcode = 0x0F;
        _rd = 0;
        _funct3 = 0;
        _rs1 = 0;
        _imm = _imm & 0x0FF00000;
        encodedInstr = _imm | _rs1 | _funct3 | _rd | _opcode;
    } else if (decodedinstr.G_instrType == G_InstrType::G_INSTR_FENCEI) {
        _opcode = 0x0F;
        _rd = 0;
        _funct3 = 0x1 << 12;
        _rs1 = 0;
        _imm = 0;
        encodedInstr = _imm | _rs1 | _funct3 | _rd | _opcode;
    } else if (decodedinstr.G_instrType == G_InstrType::G_INSTR_PRIV) {
        _opcode = 0x73;
        _rd = 0;
        _funct3 = 0x0 << 12;
        _rs1 = 0;
        if (decodedinstr.G_privInstrType == G_PrivInstrType::G_INSTR_ECALL)
            _imm = 0;
        else if (decodedinstr.G_privInstrType == G_PrivInstrType::G_INSTR_EBREAK)
            _imm = 0x1 << 20;
        else if (decodedinstr.G_privInstrType == G_PrivInstrType::G_INSTR_MRET)
            _imm = 0x302 << 20;
        encodedInstr = _imm | _rs1 | _funct3 | _rd | _opcode;
    } else if (decodedinstr.G_instrType == G_InstrType::G_INSTR_CSRRW) {
        _opcode = 0x73;
        _funct3 = 0x1 << 12;
        encodedInstr = _imm | _rs1 | _funct3 | _rd | _opcode;
    } else if (decodedinstr.G_instrType == G_InstrType::G_INSTR_CSRRS) {
        _opcode = 0x73;
        _funct3 = 0x2 << 12;
        encodedInstr = _imm | _rs1 | _funct3 | _rd | _opcode;
    } else if (decodedinstr.G_instrType == G_InstrType::G_INSTR_CSRRC) {
        _opcode = 0x73;
        _funct3 = 0x3 << 12;
        encodedInstr = _imm | _rs1 | _funct3 | _rd | _opcode;
    } else if (decodedinstr.G_instrType == G_InstrType::G_INSTR_CSRRWI) {
        _opcode = 0x73;
        _funct3 = 0x5 << 12;
        encodedInstr = _imm | _rs1 | _funct3 | _rd | _opcode;
    } else if (decodedinstr.G_instrType == G_InstrType::G_INSTR_CSRRSI) {
        _opcode = 0x73;
        _funct3 = 0x6 << 12;
        encodedInstr = _imm | _rs1 | _funct3 | _rd | _opcode;
    } else if (decodedinstr.G_instrType == G_InstrType::G_INSTR_CSRRCI) {
        _opcode = 0x73;
        _funct3 = 0x7 << 12;
        encodedInstr = _imm | _rs1 | _funct3 | _rd | _opcode;
    }

//    std::cout<<"\nEncoder result  "<< hex << encodedInstr << std::endl;
    return encodedInstr;
}

#endif //UVMSYSTEMC_ENCODER_H
