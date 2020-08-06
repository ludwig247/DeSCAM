//
// Created by ludwig on 08.12.16.
//

#ifndef PROJECT_ALU_H
#define PROJECT_ALU_H

#include "systemc.h"
#include "Interfaces.h"
#include "CPU_Interfaces.h"

class ALU : public sc_module {
public:
    //Constructor
    SC_HAS_PROCESS(ALU);

    ALU(sc_module_name name) :
            CtlToALU_port("ctl_in"),
            ALUtoCtl_port("ctl_out"),
            alu_op1(0),
            alu_op2(0) {
        SC_THREAD(run);
    }

    blocking_in<CtlToALU_IF> CtlToALU_port;
    blocking_out<ALUtoCtl_IF> ALUtoCtl_port;

    CtlToALU_IF CtlToALU_data;
    ALUtoCtl_IF ALUtoCtl_data;

    unsigned int alu_op1;
    unsigned int alu_op2;

    // thread
    void run();
};


void ALU::run() {
    while (true) {

        // Wait for operation
        CtlToALU_port->read(CtlToALU_data);

        // default
        ALUtoCtl_data.ALU_result = 0;

        // select ALU operand 1
        if (CtlToALU_data.op1_sel == CtlToALU_IF::OP_REG) {
            alu_op1 = CtlToALU_data.reg1_contents;
        } else if (CtlToALU_data.op1_sel == CtlToALU_IF::OP_IMM) {
            alu_op1 = CtlToALU_data.imm;
        } else if (CtlToALU_data.op1_sel == CtlToALU_IF::OP_PC) {
            alu_op1 = CtlToALU_data.pc_reg;
        } else {
            alu_op1 = 0;
        }

        // select ALU operand 2
        if (CtlToALU_data.op2_sel == CtlToALU_IF::OP_REG) {
            alu_op2 = CtlToALU_data.reg2_contents;
        } else if (CtlToALU_data.op2_sel == CtlToALU_IF::OP_IMM) {
            alu_op2 = CtlToALU_data.imm;
        } else if (CtlToALU_data.op2_sel == CtlToALU_IF::OP_PC) {
            alu_op2 = CtlToALU_data.pc_reg;
        } else {
            alu_op2 = 0;
        }


#if !defined(NDEBUG) && !defined(TEST)
        cout << "@ALU: Decoded ALU operands: OP1 = 0x" << hex << alu_op1 << "(hex)=" << dec << alu_op1
             << "(dec), OP2 = 0x" << hex << alu_op2 << "(hex)=" << dec << alu_op2 << "(dec)" << endl;
#endif

        // perform ALU operations
        if (CtlToALU_data.alu_fun != CtlToALU_IF::ALU_X) {
            if (CtlToALU_data.alu_fun == CtlToALU_IF::ALU_ADD) {
                ALUtoCtl_data.ALU_result = alu_op1 + alu_op2;
            } else if (CtlToALU_data.alu_fun == CtlToALU_IF::ALU_SUB) {
                ALUtoCtl_data.ALU_result = alu_op1 + (-alu_op2);
            } else if (CtlToALU_data.alu_fun == CtlToALU_IF::ALU_AND) {
                ALUtoCtl_data.ALU_result = alu_op1 & alu_op2;
            } else if (CtlToALU_data.alu_fun == CtlToALU_IF::ALU_OR) {
                ALUtoCtl_data.ALU_result = alu_op1 | alu_op2;
            } else if (CtlToALU_data.alu_fun == CtlToALU_IF::ALU_XOR) {
                ALUtoCtl_data.ALU_result = alu_op1 ^ alu_op2;
            } else if (CtlToALU_data.alu_fun == CtlToALU_IF::ALU_SLT) {
                if ((signed) alu_op1 < (signed) alu_op2) {
                    ALUtoCtl_data.ALU_result = 1;
                } else {
                    ALUtoCtl_data.ALU_result = 0;
                }
            } else if (CtlToALU_data.alu_fun == CtlToALU_IF::ALU_SLTU) {
                if (alu_op1 < alu_op2) {
                    ALUtoCtl_data.ALU_result = 1;
                } else {
                    ALUtoCtl_data.ALU_result = 0;
                }
            } else if (CtlToALU_data.alu_fun == CtlToALU_IF::ALU_SLL) {
                // shamt in alu_op2 (imm)!
                // Arithmetic and logical the same: no problem
                ALUtoCtl_data.ALU_result = alu_op1 << (alu_op2 & 0x1F);
            } else if (CtlToALU_data.alu_fun == CtlToALU_IF::ALU_SRA) {
                // shamt in alu_op2 (imm)!
                ALUtoCtl_data.ALU_result = (signed) alu_op1 >> (alu_op2 & 0x1F);
            } else if (CtlToALU_data.alu_fun == CtlToALU_IF::ALU_SRL) {
                // shamt in alu_op2 (imm)!
                ALUtoCtl_data.ALU_result = alu_op1 >> ((alu_op2) & 0x1F);
            } else if (CtlToALU_data.alu_fun == CtlToALU_IF::ALU_COPY1) {
                ALUtoCtl_data.ALU_result = alu_op1;
            }
        }

#if !defined(NDEBUG) && !defined(TEST)
        cout << "@ALU Output = 0x" << hex << ALUtoCtl_data.ALU_result << "(hex)="
             << dec << ALUtoCtl_data.ALU_result << "(dec)" << endl;
#endif

        // send ALU results to control path
        ALUtoCtl_port->write(ALUtoCtl_data);
    }

}

#endif //PROJECT_ALU_H