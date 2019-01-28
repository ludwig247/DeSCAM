//
// Created by ludwig on 14.11.17.
//

#ifndef PROJECT_DECODER_H
#define PROJECT_DECODER_H


#include "systemc.h"
#include "Interfaces.h"
#include "CPU_Interfaces.h"
#include "Utilities.h"
#include "Defines.h"

class Decoder : public sc_module {
public:

    SC_HAS_PROCESS(Decoder);

    Decoder(sc_module_name name) :
            CtlToDec_port("CtlToDec_port"),
            DecToCtl_port("DecToCtl_port"),
            encoded_instr(0),
            rec(false),
            imm_i(0),
            imm_s(0),
            imm_b(0),
            imm_u(0),
            imm_j(0),
            imm_i_sext(0),
            imm_i_shamt(0),
            imm_b_1(0),
            imm_b_2(0),
            imm_b_sext_0(0),
            imm_j_1(0),
            imm_j_2(0),
            imm_j_3(0),
            opcode(0),
            funct3(0),
            funct7(0){
        SC_THREAD(run);
    }

    // Ports
    slave_out<DecodedInstr> DecToCtl_port;
    slave_in<unsigned int> CtlToDec_port;

    // Variables
    unsigned int encoded_instr;
    DecodedInstr decoded_instr;

    bool rec;

    unsigned int imm_i;
    unsigned int imm_s;
    unsigned int imm_b;
    unsigned int imm_u;
    unsigned int imm_j;
    unsigned int imm_i_sext;
    unsigned int imm_i_shamt;
    unsigned int imm_b_1;
    unsigned int imm_b_2;
    unsigned int imm_b_sext_0;
    unsigned int imm_j_1;
    unsigned int imm_j_2;
    unsigned int imm_j_3;

    unsigned int opcode;
    unsigned int funct3;
    unsigned int funct7;

    // Thread
    void run();
};


void Decoder::run() {

    while (true) {

        // Wait for next instruction
        rec = CtlToDec_port->nb_read(encoded_instr);

        // New Instruction received;
        if (rec) {


            //Cpath
            decoded_instr.instrType = InstrTypeOld::Unknown;
            decoded_instr.encType = Error_Type;
            opcode = Sub(encoded_instr, 6, 0);
            funct3 = Sub(encoded_instr, 14, 12);
            funct7 = Sub(encoded_instr, 31, 25);

            // for all instructions:
            decoded_instr.rs1_addr = Sub(encoded_instr, RS1_MSB, RS1_LSB);
            decoded_instr.rs2_addr = Sub(encoded_instr, RS2_MSB, RS2_LSB);
            decoded_instr.rd_addr = Sub(encoded_instr, RD_MSB, RD_LSB);

            ///////////////////////////////////////
            //Instruction Type: Register-Immediate
            ///////////////////////////////////////
            if (opcode == 0x13) {

                //Sign extension
                imm_i = Sub(encoded_instr, 31, 20);
                if (Sub(imm_i, 11, 11) == 1) {
                    imm_i_sext = Cat(Fill(20), 20, imm_i, 12);
                } else {
                    imm_i_sext = imm_i;
                }

                // I type encoding
                decoded_instr.encType = I;

                // immediate sign extended
                decoded_instr.imm = imm_i_sext; // for slli,srli,srai reassigned to shamt

                //Func3 Type
                if (funct3 == 0x0) {
                    decoded_instr.instrType = InstrTypeOld::addI;

                } else if (funct3 == 0x7) {
                    decoded_instr.instrType = InstrTypeOld::andI;
                } else if (funct3 == 0x6) {
                    decoded_instr.instrType = InstrTypeOld::orI;
                } else if (funct3 == 0x4) {
                    decoded_instr.instrType = InstrTypeOld::xorI;
                } else if (funct3 == 0x2) {
                    decoded_instr.instrType = InstrTypeOld::sltI;
                } else if (funct3 == 0x3) {
                    decoded_instr.instrType = InstrTypeOld::sltIu;
                } else if (funct3 == 0x1) {
                    decoded_instr.instrType = InstrTypeOld::sllI;
                    imm_i_shamt = Sub(encoded_instr, 24, 20);
                    decoded_instr.imm = imm_i_shamt;
                } else if (funct3 == 0x5) {
                    imm_i_shamt = Sub(encoded_instr, 24, 20);
                    if (funct7 == 0) {
                        decoded_instr.instrType = InstrTypeOld::srlI;
                        decoded_instr.imm = imm_i_shamt;
                    } else if (funct7 == 32) {
                        decoded_instr.instrType = InstrTypeOld::sraI;
                        decoded_instr.imm = imm_i_shamt;
                    }
                }
            }
                ///////////////////////////////////////
                //Instruction Type: Register-Register
                ///////////////////////////////////////
            else if (opcode == 0x33) {

                // R type encoding
                decoded_instr.encType = R;

                // not used
                decoded_instr.imm = 0;

                //Func3 Type
                if (funct3 == 0x0) {
                    if (funct7 == 0) decoded_instr.instrType = InstrTypeOld::add;
                    if (funct7 == 32) decoded_instr.instrType = InstrTypeOld::sub;
                } else if (funct3 == 0x01) {
                    decoded_instr.instrType = InstrTypeOld::sll_Instr;
                } else if (funct3 == 0x02) {
                    decoded_instr.instrType = InstrTypeOld::slt;
                } else if (funct3 == 0x03) {
                    decoded_instr.instrType = InstrTypeOld::sltu;
                } else if (funct3 == 0x04) {
                    decoded_instr.instrType = InstrTypeOld::Xor_Instr;
                } else if (funct3 == 0x05) {
                    if (funct7 == 0) decoded_instr.instrType = InstrTypeOld::srl_Instr;
                    if (funct7 == 32) decoded_instr.instrType = InstrTypeOld::sra_Instr;
                } else if (funct3 == 0x06) {
                    decoded_instr.instrType = InstrTypeOld::Or_Instr;
                } else if (funct3 == 0x07) {
                    decoded_instr.instrType = InstrTypeOld::And_Instr;
                }
            }
                ///////////////////////////////////////
                //Instruction Type: Conditional branch
                ///////////////////////////////////////
            else if (opcode == 0x63) {

                // 12 bit B immediate encodes signed offsets in multiples of 2 !!!!!

                //Compute immediate
                imm_b_1 = Cat(Sub(encoded_instr, 31, 31), 1, Sub(encoded_instr, 7, 7), 1);
                imm_b_2 = Cat(Sub(encoded_instr, 30, 25), 6, Sub(encoded_instr, 11, 8), 4);
                imm_b = Cat(imm_b_1, 2, imm_b_2, 10);

                if (Sub(imm_b, 11, 11) == 1) {
                    imm_b_sext_0 = Cat(Fill(19), 19, imm_b, 12);
                } else {
                    imm_b_sext_0 = imm_b;
                }
                imm_b = Cat(imm_b_sext_0, 31, 0, 1);

                // B type encoding
                decoded_instr.encType = B;

                // always
                decoded_instr.imm = imm_b;

                //Func3 Type
                if (funct3 == 0x0) {
                    decoded_instr.instrType = InstrTypeOld::beq;
                } else if (funct3 == 0x01) {
                    decoded_instr.instrType = InstrTypeOld::bne;
                } else if (funct3 == 0x04) {
                    decoded_instr.instrType = InstrTypeOld::blt;
                } else if (funct3 == 0x05) {
                    decoded_instr.instrType = InstrTypeOld::bge;
                } else if (funct3 == 0x06) {
                    decoded_instr.instrType = InstrTypeOld::bltu;
                } else if (funct3 == 0x07) {
                    decoded_instr.instrType = InstrTypeOld::bgeu;
                }
            }


                ///////////////////////////////////////
                //Instruction Type: Load
                ///////////////////////////////////////
            else if (opcode == 0x03) {
                //Compute immediate
                imm_i = Sub(encoded_instr, 31, 20);
                //Sign extension
                if (Sub(imm_i, 11, 11) == 1) {
                    imm_i_sext = Cat(Fill(20), 20, imm_i, 12);
                } else imm_i_sext = imm_i;

                // I type encoding
                decoded_instr.encType = I;

                // immediate sign extended
                decoded_instr.imm = imm_i_sext;

                //Func3 Type
                if (funct3 == 0x0) {
                    decoded_instr.instrType = InstrTypeOld::lb;
                } else if (funct3 == 0x01) {
                    decoded_instr.instrType = InstrTypeOld::lh;
                } else if (funct3 == 0x02) {
                    decoded_instr.instrType = InstrTypeOld::lw;
                } else if (funct3 == 0x04) {
                    decoded_instr.instrType = InstrTypeOld::lbu;
                } else if (funct3 == 0x05) {
                    decoded_instr.instrType = InstrTypeOld::lhu;
                }
            }

                ///////////////////////////////////////
                //Instruction Type: Jumps
                ///////////////////////////////////////
            else if (opcode == 0x37) {
                imm_u = Sub(encoded_instr, 31, 12);
                //FIXME: is the 12-bit shift done here or in the ALU ? For now here.
                imm_u = Cat(imm_u, 20, 0, 12);
                decoded_instr.imm = imm_u;
                // U type encoding
                decoded_instr.encType = U;
                decoded_instr.instrType = InstrTypeOld::lui;
            } else if (opcode == 0x17) {
                imm_u = Sub(encoded_instr, 31, 12);
                //FIXME: is the 12-bit shift done here or in the ALU ? For now here.
                imm_u = Cat(imm_u, 20, 0, 12);
                decoded_instr.imm = imm_u;
                // U type encoding
                decoded_instr.encType = U;
                decoded_instr.instrType = InstrTypeOld::auipc;
            } else if (opcode == 0x6F) {

                imm_j_1 = Cat(Sub(encoded_instr, 31, 31), 1, Sub(encoded_instr, 19, 12), 8);
                imm_j_2 = Cat(Sub(encoded_instr, 20, 20), 1, Sub(encoded_instr, 30, 21), 10);
                imm_j_3 = Cat(imm_j_2, 11, 0, 1);

                imm_j = Cat(imm_j_1, 9, imm_j_3, 12);
                //Sign extension
                if (Sub(encoded_instr, 31, 31) == 1) {
                    imm_j = Cat(Fill(11), 11, imm_j, 21);
                }

                decoded_instr.imm = imm_j;

                // J type encoding
                decoded_instr.encType = J;
                decoded_instr.instrType = InstrTypeOld::jal;
            } else if (opcode == 0x67) {
                imm_i = Sub(encoded_instr, 31, 20);
                //Sign extension
                if (Sub(imm_i, 11, 11) == 1) {
                    imm_i = Cat(Fill(20), 20, imm_i, 12);
                }

                decoded_instr.imm = imm_i;

                // I type encoding
                decoded_instr.encType = I;
                decoded_instr.instrType = InstrTypeOld::jalr;
            }

                ///////////////////////////////////////
                //Instruction Type: Store
                ///////////////////////////////////////
            else if (opcode == 0x23) {

                imm_s = Cat(Sub(encoded_instr, 31, 25), 7, Sub(encoded_instr, 11, 7), 5);
                //Sign extend
                if (Sub(imm_s, 11, 11) == 1) {
                    imm_s = Cat(Fill(20), 20, imm_s, 12);
                }

                // always for stores (s type)
                decoded_instr.imm = imm_s;

                // S type encoding
                decoded_instr.encType = S;

                if (funct3 == 0) {
                    decoded_instr.instrType = InstrTypeOld::sb;
                } else if (funct3 == 1) {
                    decoded_instr.instrType = InstrTypeOld::sh;
                } else if (funct3 == 2) {
                    decoded_instr.instrType = InstrTypeOld::sw;
                }

            }
        }

        /*
        // Temporarily deal like this with unknown instructions
        if (decoded_instr.instrType == InstrTypeOld::Unknown) {
            std::cout << "@Dec: Unknown instruction... Terminating!" << std::endl;
            exit(0);
        }


        

#ifndef NDEBUG
        cout << "@Dec: Decoding instr 0x" << hex << encoded_instr << ", InstrType = "
             << stringInstrType(decoded_instr.instrType) << endl;

        cout << "@Dec: Immediate =  0x" << hex << decoded_instr.imm << "(hex) = "
             << dec << decoded_instr.imm << " (dec)" << endl;
#endif
*/

        // Notify the CPU with the decoded instruction
        DecToCtl_port->nb_write(decoded_instr);

    }
}


#endif //PROJECT_DECODER_H
