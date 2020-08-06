//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 10/24/18.
//

#ifndef UVMSYSTEMC_INSTRUCTION_CONSTRAINTS_H
#define UVMSYSTEMC_INSTRUCTION_CONSTRAINTS_H

#include "scv.h"
#include "../../Golden_Reference/GOLDEN_CPU_Interfaces.h"

enum instr_constraint_type {R_format, I_I_format, I_L_format, I_J_format, I_M_format, I_S_format, S_format, B_format, U_format, J_format};


class R_Type : virtual public scv_constraint_base {
public:
    scv_smart_ptr<G_DecodedInstr> decodedInstr;
SCV_CONSTRAINT_CTOR(R_Type) {
        std::list<G_InstrType> allowed_instr({G_InstrType::G_INSTR_ADD, G_InstrType::G_INSTR_SUB, G_InstrType::G_INSTR_SLL, G_InstrType::G_INSTR_SLT,
                                              G_InstrType::G_INSTR_SLTU, G_InstrType::G_INSTR_XOR, G_InstrType::G_INSTR_SRL, G_InstrType::G_INSTR_SRA,
                                              G_InstrType::G_INSTR_OR, G_InstrType::G_INSTR_AND});
        decodedInstr->G_instrType.keep_only(allowed_instr);
        decodedInstr->G_encType.keep_only(G_EncType::G_ENC_R);
        SCV_CONSTRAINT(decodedInstr->G_rs1_addr() < 32);
        SCV_CONSTRAINT(decodedInstr->G_rs2_addr() < 32);
        SCV_CONSTRAINT(decodedInstr->G_rd_addr() < 32);
        SCV_CONSTRAINT(decodedInstr->G_imm() = 0);//doesn't have an effect
    }
};

class I_I_Type : virtual public scv_constraint_base {
public:
    scv_smart_ptr<G_DecodedInstr> decodedInstr;
SCV_CONSTRAINT_CTOR(I_I_Type) {
        std::list<G_InstrType> allowed_instr({G_InstrType::G_INSTR_ADDI, G_InstrType::G_INSTR_SLLI, G_InstrType::G_INSTR_SLTI, G_InstrType::G_INSTR_SLTUI,
                                              G_InstrType::G_INSTR_XORI, G_InstrType::G_INSTR_SRLI, G_InstrType::G_INSTR_SRAI, G_InstrType::G_INSTR_ORI,
                                              G_InstrType::G_INSTR_ANDI});
        decodedInstr->G_instrType.keep_only(allowed_instr);
        decodedInstr->G_encType.keep_only(G_EncType::G_ENC_I_I);
        SCV_CONSTRAINT(decodedInstr->G_rs1_addr() < 32);
        SCV_CONSTRAINT(decodedInstr->G_rs2_addr() = 0);//doesn't have an effect
        SCV_CONSTRAINT(decodedInstr->G_rd_addr() < 32);
        SCV_CONSTRAINT(decodedInstr->G_imm() <= 0xFFF);
    }
};

class I_L_Type : virtual public scv_constraint_base {
public:
    scv_smart_ptr<G_DecodedInstr> decodedInstr;
SCV_CONSTRAINT_CTOR(I_L_Type) {
        std::list<G_InstrType> allowed_instr({G_InstrType::G_INSTR_LB, G_InstrType::G_INSTR_LH, G_InstrType::G_INSTR_LBU, G_InstrType::G_INSTR_LHU, G_InstrType::G_INSTR_LW});
        decodedInstr->G_instrType.keep_only(allowed_instr);
        decodedInstr->G_encType.keep_only(G_EncType::G_ENC_I_L);
        SCV_CONSTRAINT(decodedInstr->G_rs1_addr() < 32);
        SCV_CONSTRAINT(decodedInstr->G_rs2_addr() = 0);//doesn't have an effect
        SCV_CONSTRAINT(decodedInstr->G_rd_addr() < 32);
        SCV_CONSTRAINT(decodedInstr->G_imm() <= 0xFFF);
    }
};

class I_J_Type : virtual public scv_constraint_base {
public:
    scv_smart_ptr<G_DecodedInstr> decodedInstr;
SCV_CONSTRAINT_CTOR(I_J_Type) {
        std::list<G_InstrType> allowed_instr({G_InstrType::G_INSTR_JALR});
        decodedInstr->G_instrType.keep_only(allowed_instr);
        decodedInstr->G_encType.keep_only(G_EncType::G_ENC_I_J);
        SCV_CONSTRAINT(decodedInstr->G_rs1_addr() < 32);
        SCV_CONSTRAINT(decodedInstr->G_rs2_addr() = 0);//doesn't have an effect
        SCV_CONSTRAINT(decodedInstr->G_rd_addr() < 32);
        SCV_CONSTRAINT(decodedInstr->G_imm() <= 0xFFF);
    }
};

class I_M_Type : virtual public scv_constraint_base {
public:
    scv_smart_ptr<G_DecodedInstr> decodedInstr;
SCV_CONSTRAINT_CTOR(I_M_Type) {
        std::list<G_InstrType> allowed_instr({G_InstrType::G_INSTR_FENCE, G_InstrType::G_INSTR_FENCEI});
        decodedInstr->G_instrType.keep_only(allowed_instr);
        decodedInstr->G_encType.keep_only(G_EncType::G_ENC_I_M);
        SCV_CONSTRAINT(decodedInstr->G_rs1_addr() < 32);
        SCV_CONSTRAINT(decodedInstr->G_rs2_addr() = 0);//doesn't have an effect
        SCV_CONSTRAINT(decodedInstr->G_rd_addr() < 32);
        SCV_CONSTRAINT(decodedInstr->G_imm() <= 0x0FF);
    }
};

class I_S_Type : virtual public scv_constraint_base {
public:
    scv_smart_ptr<G_DecodedInstr> decodedInstr;
SCV_CONSTRAINT_CTOR(I_S_Type) {
        std::list<G_InstrType> allowed_instr({G_InstrType::G_INSTR_CSRRW, G_InstrType::G_INSTR_CSRRS, G_InstrType::G_INSTR_CSRRC,
                                              G_InstrType::G_INSTR_CSRRWI, G_InstrType::G_INSTR_CSRRSI, G_InstrType::G_INSTR_CSRRCI,
                                              G_InstrType::G_INSTR_PRIV});
        decodedInstr->G_instrType.keep_only(allowed_instr);
        decodedInstr->G_encType.keep_only(G_EncType::G_ENC_I_S);
        SCV_CONSTRAINT(decodedInstr->G_rs1_addr() < 32);
        SCV_CONSTRAINT(decodedInstr->G_rs2_addr() = 0);//doesn't have an effect
        SCV_CONSTRAINT(decodedInstr->G_rd_addr() < 32);
        std::list<unsigned int> allowed_CSRs({0x300, 0x301, 0x302, 0x303, 0x304, 0x305, 0x306,
                                             0x340, 0x341, 0x342, 0x343, 0x344,
                                             0xF11, 0xF12, 0xF13, 0xF14});
        decodedInstr->G_imm.keep_only(allowed_CSRs);
    }
};

class S_Type : virtual public scv_constraint_base {
public:
    scv_smart_ptr<G_DecodedInstr> decodedInstr;
SCV_CONSTRAINT_CTOR(S_Type) {
        std::list<G_InstrType> allowed_instr({G_InstrType::G_INSTR_SB, G_InstrType::G_INSTR_SH, G_InstrType::G_INSTR_SW});
        decodedInstr->G_instrType.keep_only(allowed_instr);
        decodedInstr->G_encType.keep_only(G_EncType::G_ENC_S);
        SCV_CONSTRAINT(decodedInstr->G_rs1_addr() < 32);
        SCV_CONSTRAINT(decodedInstr->G_rs2_addr() < 32);
        SCV_CONSTRAINT(decodedInstr->G_rd_addr() = 0);//doesn't have an effect
        SCV_CONSTRAINT(decodedInstr->G_imm() <= 0xFFF);
    }
};

class B_Type : virtual public scv_constraint_base {
public:
    scv_smart_ptr<G_DecodedInstr> decodedInstr;
SCV_CONSTRAINT_CTOR(B_Type) {
        std::list<G_InstrType> allowed_instr({G_InstrType::G_INSTR_BEQ, G_InstrType::G_INSTR_BNE, G_InstrType::G_INSTR_BLT,
                                              G_InstrType::G_INSTR_BGE, G_InstrType::G_INSTR_BLTU, G_InstrType::G_INSTR_BGEU});
        decodedInstr->G_instrType.keep_only(allowed_instr);
        decodedInstr->G_encType.keep_only(G_EncType::G_ENC_B);
        SCV_CONSTRAINT(decodedInstr->G_rs1_addr() < 32);
        SCV_CONSTRAINT(decodedInstr->G_rs2_addr() < 32);
        SCV_CONSTRAINT(decodedInstr->G_rd_addr() = 0);//doesn't have an effect
        SCV_CONSTRAINT(decodedInstr->G_imm() <= 0x1FFF);
    }
};

class U_Type : virtual public scv_constraint_base {
public:
    scv_smart_ptr<G_DecodedInstr> decodedInstr;
SCV_CONSTRAINT_CTOR(U_Type) {
        std::list<G_InstrType> allowed_instr({G_InstrType::G_INSTR_LUI, G_InstrType::G_INSTR_AUIPC});
        decodedInstr->G_instrType.keep_only(allowed_instr);
        decodedInstr->G_encType.keep_only(G_EncType::G_ENC_U);
        SCV_CONSTRAINT(decodedInstr->G_rs1_addr() = 0);//doesn't have an effect
        SCV_CONSTRAINT(decodedInstr->G_rs2_addr() = 0);//doesn't have an effect
        SCV_CONSTRAINT(decodedInstr->G_rd_addr() < 32);
        SCV_CONSTRAINT(decodedInstr->G_imm() <= 0xFFFFFFFF);
    }
};

class J_Type : virtual public scv_constraint_base {
public:
    scv_smart_ptr<G_DecodedInstr> decodedInstr;
SCV_CONSTRAINT_CTOR(J_Type) {
        std::list<G_InstrType> allowed_instr({G_InstrType::G_INSTR_JAL});
        decodedInstr->G_instrType.keep_only(allowed_instr);
        decodedInstr->G_encType.keep_only(G_EncType::G_ENC_J);
        SCV_CONSTRAINT(decodedInstr->G_rs1_addr() = 0);//doesn't have an effect
        SCV_CONSTRAINT(decodedInstr->G_rs2_addr() = 0);//doesn't have an effect
        SCV_CONSTRAINT(decodedInstr->G_rd_addr() < 32);
        SCV_CONSTRAINT(decodedInstr->G_imm() <= 0xFFFFF);
    }
};



//class Reg_Imm_Instr : virtual public scv_constraint_base {
//public:
//    scv_smart_ptr<G_DecodedInstr> decodedInstr;
//
//SCV_CONSTRAINT_CTOR(Reg_Imm_Instr) {
//        std::list<G_InstrType> allowed_instr({G_InstrType::G_INSTR_ADDI, G_InstrType::G_INSTR_ANDI, G_InstrType::G_INSTR_ORI, G_InstrType::G_INSTR_XORI,
//                                          G_InstrType::G_INSTR_SLTI, G_InstrType::G_INSTR_SLTUI, G_InstrType::G_INSTR_SLLI, G_InstrType::G_INSTR_SRLI,
//                                          G_InstrType::G_INSTR_SRAI});
//        decodedInstr->G_instrType.keep_only(allowed_instr);
//        decodedInstr->G_encType.keep_only(G_EncType::G_ENC_I_I);
//        SCV_CONSTRAINT(decodedInstr->G_rs1_addr() < 32);
//        SCV_CONSTRAINT(decodedInstr->G_rs2_addr() < 32);//don't care
//        SCV_CONSTRAINT(decodedInstr->G_rd_addr() < 32);
//        SCV_CONSTRAINT(decodedInstr->G_imm() <= 0xFFF);
//    }
//};
//
//class Reg_Reg_Instr : virtual public scv_constraint_base {
//public:
//    scv_smart_ptr<G_DecodedInstr> decodedInstr;
//
//SCV_CONSTRAINT_CTOR(Reg_Reg_Instr) {
//        std::list<G_InstrType> allowed_instr({G_InstrType::G_INSTR_ADD, G_InstrType::G_INSTR_SUB, G_InstrType::G_INSTR_SLL, G_InstrType::G_INSTR_SLT,
//                                          G_InstrType::G_INSTR_SLTU, G_InstrType::G_INSTR_XOR, G_InstrType::G_INSTR_SRL, G_InstrType::G_INSTR_SRA,
//                                          G_InstrType::G_INSTR_OR, G_InstrType::G_INSTR_AND});
//        decodedInstr->G_instrType.keep_only(allowed_instr);
//        decodedInstr->G_encType.keep_only(G_EncType::G_ENC_R);
//        SCV_CONSTRAINT(decodedInstr->G_rs1_addr() < 32);
//        SCV_CONSTRAINT(decodedInstr->G_rs2_addr() < 32);
//        SCV_CONSTRAINT(decodedInstr->G_rd_addr() < 32);
//        SCV_CONSTRAINT(decodedInstr->G_imm() < 1);//don't care
//    }
//};

inline void constrain_instr(scv_smart_ptr<G_DecodedInstr>& sp, instr_constraint_type t){
    switch(t){
        case R_format:{
            R_Type r_type("R_Type");
            sp->use_constraint(r_type.decodedInstr);
            break;
        }
        case I_I_format:{
            I_I_Type i_i_type("I_I_Type");
            sp->use_constraint(i_i_type.decodedInstr);
            break;
        }
        case I_L_format:{
            I_L_Type i_l_type("I_L_Type");
            sp->use_constraint(i_l_type.decodedInstr);
            break;
        }
        case I_J_format:{
            I_J_Type i_j_type("I_J_Type");
            sp->use_constraint(i_j_type.decodedInstr);
            break;
        }
        case I_M_format:{
            I_M_Type i_m_type("I_M_Type");
            sp->use_constraint(i_m_type.decodedInstr);
            break;
        }
        case I_S_format:{
            I_S_Type i_s_type("I_S_Type");
            sp->use_constraint(i_s_type.decodedInstr);
            break;
        }
        case S_format:{
            S_Type s_type("S_Type");
            sp->use_constraint(s_type.decodedInstr);
            break;
        }
        case B_format:{
            B_Type b_type("B_Type");
            sp->use_constraint(b_type.decodedInstr);
            break;
        }
        case U_format:{
            U_Type u_type("U_Type");
            sp->use_constraint(u_type.decodedInstr);
            break;
        }
        case J_format:{
            J_Type j_type("J_Type");
            sp->use_constraint(j_type.decodedInstr);
            break;
        }
        default:
            break;
    }
}
#endif //UVMSYSTEMC_INSTRUCTION_CONSTRAINTS_H
