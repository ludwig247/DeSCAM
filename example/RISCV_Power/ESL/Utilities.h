#ifndef PROJECT_UTILITIES_H
#define PROJECT_UTILITIES_H

#include "Defines.h"


/**
 * \brief Decodes a binary instruction to "Decoded instruction format"
 * @param instr
 * @return decoded instruction format
 */

DecodedInstr decode_instruction(unsigned int instr) {

    DecodedInstr dataOut;
    int imm_i;
    int imm_s;
    int imm_b;
    int imm_u;
    int imm_j;
    int imm_z;
    int imm_i_sext;
    int imm_i_shamt;
    int imm_s_sext;
    int imm_b_sext;
    int imm_u_sext;
    int imm_j_sext;

    int imm_i_sextU;
    int imm_i_sext_shamt;
    int imm_s_sext_shamt;

    //Cpath
    dataOut.instrType = InstrType::Unknown;
    dataOut.encType = Error_Type;
    int opcode = Sub(instr, 6, 0);
    int funct3 = Sub (instr, 14, 12);
    int funct7 = Sub (instr, 31, 25);

    // for all instructions:
    dataOut.rs1_addr = Sub(instr, RS1_MSB, RS1_LSB);
    dataOut.rs2_addr = Sub(instr, RS2_MSB, RS2_LSB);
    dataOut.rd_addr = Sub(instr, RD_MSB, RD_LSB);


    ///////////////////////////////////////
    //Instruction Type: Register-Immediate
    ///////////////////////////////////////
    if (opcode == 0x13) {

        //Sign extension
        imm_i = Sub(instr, 31, 20);
        if (Sub(imm_i, 11, 11) == 1) {
            imm_i_sext = Cat(Fill(20), 20, imm_i, 12);
        } else {
            imm_i_sext = imm_i;
        }

        // I type encoding
        dataOut.encType = I;

        // immediate sign extended
        dataOut.imm = imm_i_sext; // for slli,srli,srai reassigned to shamt

        //Func3 Type
        if (funct3 == 0x0) {
            dataOut.instrType = InstrType::addI;

        } else if (funct3 == 0x7) {
            dataOut.instrType = InstrType::andI;
        } else if (funct3 == 0x6) {
            dataOut.instrType = InstrType::orI;
        } else if (funct3 == 0x4) {
            dataOut.instrType = InstrType::xorI;
        } else if (funct3 == 0x2) {
            dataOut.instrType = InstrType::sltI;
        } else if (funct3 == 0x3) {
            dataOut.instrType = InstrType::sltIu;
        } else if (funct3 == 0x1) {
            dataOut.instrType = InstrType::sllI;
            imm_i_shamt = Sub(instr, 24, 20);
            dataOut.imm = imm_i_shamt;
        } else if (funct3 == 0x5) {
            imm_i_shamt = Sub(instr, 24, 20);
            if (funct7 == 0) {
                dataOut.instrType = InstrType::srlI;
                dataOut.imm = imm_i_shamt;
            } else if (funct7 == 32) {
                dataOut.instrType = InstrType::sraI;
                dataOut.imm = imm_i_shamt;
            }
        }
    }
    ///////////////////////////////////////
    //Instruction Type: Register-Register
    ///////////////////////////////////////
    if (opcode == 0x33) {

        // R type encoding
        dataOut.encType = R;

        // not used
        dataOut.imm = 0;

        //Func3 Type
        if (funct3 == 0x0) {
            if (funct7 == 0) dataOut.instrType = InstrType::add;
            if (funct7 == 32) dataOut.instrType = InstrType::sub;
        } else if (funct3 == 0x01) {
            dataOut.instrType = InstrType::sll_Instr;
        } else if (funct3 == 0x02) {
            dataOut.instrType = InstrType::slt;
        } else if (funct3 == 0x03) {
            dataOut.instrType = InstrType::sltu;
        } else if (funct3 == 0x04) {
            dataOut.instrType = InstrType::Xor_Instr;
        } else if (funct3 == 0x05) {
            if (funct7 == 0) dataOut.instrType = InstrType::srl_Instr;
            if (funct7 == 32) dataOut.instrType = InstrType::sra_Instr;
        } else if (funct3 == 0x06) {
            dataOut.instrType = InstrType::Or_Instr;
        } else if (funct3 == 0x07) {
            dataOut.instrType = InstrType::And_Instr;
        }
    }
    ///////////////////////////////////////
    //Instruction Type: Conditional branch
    ///////////////////////////////////////
    if (opcode == 0x63) {

        // 12 bit B immediate encodes signed offsets in multiples of 2 !!!!!

        //Compute immediate
        int imm_b_1 = Cat(Sub(instr, 31, 31), 1, Sub(instr, 7, 7), 1);
        int imm_b_2 = Cat(Sub(instr, 30, 25), 6, Sub(instr, 11, 8), 4);
        int imm_b = Cat(imm_b_1, 2, imm_b_2, 10);
        int imm_b_sext_0;
        if (Sub(imm_b, 11, 11) == 1) {
            imm_b_sext_0 = Cat(Fill(19), 19, imm_b, 12);
        } else {
            imm_b_sext_0 = imm_b;
        }
        imm_b = Cat(imm_b_sext_0, 31, 0, 1);

        // B type encoding
        dataOut.encType = B;

        // always
        dataOut.imm = imm_b;

        //Func3 Type
        if (funct3 == 0x0) {
            dataOut.instrType = InstrType::beq;
        } else if (funct3 == 0x01) {
            dataOut.instrType = InstrType::bne;
        } else if (funct3 == 0x04) {
            dataOut.instrType = InstrType::blt;
        } else if (funct3 == 0x05) {
            dataOut.instrType = InstrType::bge;
        } else if (funct3 == 0x06) {
            dataOut.instrType = InstrType::bltu;
        } else if (funct3 == 0x07) {
            dataOut.instrType = InstrType::bgeu;
        }
    }


    ///////////////////////////////////////
    //Instruction Type: Load
    ///////////////////////////////////////
    if (opcode == 0x03) {
        //Compute immediate
        imm_i = Sub(instr, 31, 20);
        //Sign extension
        int imm_i_sext;
        if (Sub(imm_i, 11, 11) == 1) {
            imm_i_sext = Cat(Fill(20), 20, imm_i, 12);
        } else imm_i_sext = imm_i;

        // I type encoding
        dataOut.encType = I;

        // immediate sign extended
        dataOut.imm = imm_i_sext;

        //Func3 Type
        if (funct3 == 0x0) {
            dataOut.instrType = InstrType::lb;
        } else if (funct3 == 0x01) {
            dataOut.instrType = InstrType::lh;
        } else if (funct3 == 0x02) {
            dataOut.instrType = InstrType::lw;
        } else if (funct3 == 0x04) {
            dataOut.instrType = InstrType::lbu;
        } else if (funct3 == 0x05) {
            dataOut.instrType = InstrType::lhu;
        }
    }

    ///////////////////////////////////////
    //Instruction Type: Jumps
    ///////////////////////////////////////
    if (opcode == 0x37) {
        imm_u = Sub(instr, 31, 12);
        //FIXME: is the 12-bit shift done here or in the ALU ? For now here.
        imm_u = Cat(imm_u, 20, 0, 12);
        dataOut.imm = imm_u;
        // U type encoding
        dataOut.encType = U;
        dataOut.instrType = InstrType::lui;
    }
    if (opcode == 0x17) {
        imm_u = Sub(instr, 31, 12);
        //FIXME: is the 12-bit shift done here or in the ALU ? For now here.
        imm_u = Cat(imm_u, 20, 0, 12);
        dataOut.imm = imm_u;
        // U type encoding
        dataOut.encType = U;
        dataOut.instrType = InstrType::auipc;
    }
    if (opcode == 0x6F) {

        int imm_j_1 = Cat(Sub(instr, 31, 31), 1, Sub(instr, 19, 12), 8);
        int imm_j_2 = Cat(Sub(instr, 20, 20), 1, Sub(instr, 30, 21), 10);
        int imm_j_3 = Cat(imm_j_2, 11, 0, 1);

        imm_j = Cat(imm_j_1, 9, imm_j_3, 12);
        //Sign extension
        if (Sub(instr, 31, 31) == 1) {
            imm_j = Cat(Fill(11), 11, imm_j, 21);
        }

        dataOut.imm = imm_j;

        // J type encoding
        dataOut.encType = J;
        dataOut.instrType = InstrType::jal;
    }
    if (opcode == 0x67) {
        imm_i = Sub(instr, 31, 20);
        //Sign extension
        if (Sub(imm_i, 11, 11) == 1) {
            imm_i = Cat(Fill(20), 20, imm_i, 12);
        }

        dataOut.imm = imm_i;

        // I type encoding
        dataOut.encType = I;
        dataOut.instrType = InstrType::jalr;
    }

    ///////////////////////////////////////
    //Instruction Type: Store
    ///////////////////////////////////////
    if (opcode == 0x23) {

        imm_s = Cat(Sub(instr, 31, 25), 7, Sub(instr, 11, 7), 5);
        //Sign extend
        if (Sub(imm_s, 11, 11) == 1) {
            imm_s = Cat(Fill(20), 20, imm_s, 12);
        }

        // always for stores (s type)
        dataOut.imm = imm_s;

        // S type encoding
        dataOut.encType = S;

        if (funct3 == 0) {
            dataOut.instrType = InstrType::sb;
        } else if (funct3 == 1) {
            dataOut.instrType = InstrType::sh;
        } else if (funct3 == 2) {
            dataOut.instrType = InstrType::sw;
        }

    }

    // Temporarily deal like this with unknown instructions
    if (dataOut.instrType == InstrType::Unknown) {
        std::cout << "@Dec: Unknown instruction... Terminating!" << std::endl;
        exit(0);
    }

    return dataOut;
}


std::string stringInstrType(InstrType toPrint) {

    std::string s;

    switch (toPrint) {
        case InstrType::Unknown:
            s = "UNKNOWN";
            break;
        case InstrType::addI:
            s = "ADDI";
            break;
        case InstrType::andI:
            s = "ANDI";
            break;
        case InstrType::orI:
            s = "ORI";
            break;
        case InstrType::xorI:
            s = "XORI";
            break;
        case InstrType::sltI:
            s = "SLTI";
            break;
        case InstrType::sltIu:
            s = "SLTIU";
            break;
        case InstrType::sllI:
            s = "SLLI";
            break;
        case InstrType::srlI:
            s = "SRLI";
            break;
        case InstrType::sraI:
            s = "SRAI";
            break;
        case InstrType::add:
            s = "ADD";
            break;
        case InstrType::sub:
            s = "SUB";
            break;
        case InstrType::sll_Instr:
            s = "SLL";
            break;
        case InstrType::slt:
            s = "SLT";
            break;
        case InstrType::sltu:
            s = "SLTU";
            break;
        case InstrType::Xor_Instr:
            s = "XOR";
            break;
        case InstrType::srl_Instr:
            s = "SRL";
            break;
        case InstrType::sra_Instr:
            s = "SRA";
            break;
        case InstrType::Or_Instr:
            s = "OR";
            break;
        case InstrType::And_Instr:
            s = "AND";
            break;
        case InstrType::beq:
            s = "BEQ";
            break;
        case InstrType::bne:
            s = "BNE";
            break;
        case InstrType::blt:
            s = "BLT";
            break;
        case InstrType::bge:
            s = "BGE";
            break;
        case InstrType::bltu:
            s = "BLTU";
            break;
        case InstrType::bgeu:
            s = "BGEU";
            break;
        case InstrType::lb:
            s = "LB";
            break;
        case InstrType::lh:
            s = "LH";
            break;
        case InstrType::lw:
            s = "LW";
            break;
        case InstrType::lbu:
            s = "LBU";
            break;
        case InstrType::lhu:
            s = "LHU";
            break;
        case InstrType::lui:
            s = "LUI";
            break;
        case InstrType::auipc:
            s = "AUIPC";
            break;
        case InstrType::jal:
            s = "JAL";
            break;
        case InstrType::jalr:
            s = "JALR";
            break;
        case InstrType::sb:
            s = "SB";
            break;
        case InstrType::sh:
            s = "SH";
            break;
        case InstrType::sw:
            s = "SW";
            break;
        default:
            NULL;
            break;
    }
    return s;
}


#endif  //PROJECT_UTILITIES_H

