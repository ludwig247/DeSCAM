//
// Created by ludwig on 08.12.16.
//

#ifndef PROJECT_DPATH_H
#define PROJECT_DPATH_H

#include "systemc.h"

#include "Interfaces.h"
#include "CPU_Interfaces.h"
#include "Defines.h"

struct Dpath : public sc_module {

    //Constructor
    SC_HAS_PROCESS(Dpath);

    Dpath(sc_module_name name) :
            fromDecoder("decoded_instruction"),
            fromMemory("store/load_done"),
            toMemory("to_memory"),
            reg_in("reg_in"),
            reg_out("reg_out"),
            ctlIn("ctl_in"),
            ctlOut("ctl_out"),
            pc_reg(START_ADDR),
            pc_next(START_ADDR),
            alu_op1(0),
            alu_op2(0),
            alu_out(0),
            wb_data(0),
            br_target(0),
            jmp_target(0),
            jump_reg_target(0),
            alu_shamt(0) {
        SC_THREAD(receive);
    }


    //Ports
    blocking_out<MemoryAccess> toMemory;
    blocking_in<DecodedInstr> fromDecoder;
    blocking_in<int> fromMemory;

    blocking_in<RegOutput> reg_in;
    blocking_out<RegInput> reg_out;

    blocking_in<CtlToDatIo> ctlIn;
    blocking_out<DatToCtlIo> ctlOut;

    DecodedInstr decodedInstr;
    MemoryAccess memoryAccess;

    RegOutput reg_data;
    RegInput reg_req;

    CtlToDatIo ctl;
    DatToCtlIo datToCtl;

    int instr;
    int pc_reg;
    int pc_next;

    int alu_op1;
    int alu_op2;
    unsigned int alu_op1U;
    unsigned int alu_op2U;
    int alu_out;

    int wb_data;

    int br_target;
    int jmp_target;
    int jump_reg_target;
    int alu_shamt;


    void receive() {
        while (true) {
            //Fetch next instruction from memory
            memoryAccess.addrIn = pc_reg;
            //Request instruction
            memoryAccess.req = MemoryAccess::MEM_RD_I;
            //Send request to memory
            toMemory->write(memoryAccess);
            //Read decoded instruction from decoder //FIXME: What happens in case of a load/store?
            fromDecoder->read(decodedInstr);

#ifdef DEBUG
            std::cout << "@Dpath: Read instr 0x" << std::hex << decodedInstr.instr << " opcode 0x"
                      << decodedInstr.opcode << std::endl;
#endif

            //
            // Get register contents.
            //
            reg_req.src1 = decodedInstr.rs1_addr;
            reg_req.src2 = decodedInstr.rs2_addr;

            reg_req.write = 0;
            reg_req.req = RegInput::REG_RD;

            // request data from regs
            reg_out->write(reg_req);

            //receive data
            reg_in->read(reg_data);

            //
            // Provide control block with input.
            //

            // datToCtl.instr = instr;
            datToCtl.opcode = decodedInstr.opcode;
            datToCtl.funct3 = decodedInstr.funct3;
            datToCtl.funct7 = decodedInstr.funct7;
            datToCtl.instrType = decodedInstr.instrType;
            datToCtl.encType = decodedInstr.encType;


            if (reg_data.contents1 == reg_data.contents2) {
                datToCtl.br_eq = true;
            } else {
                datToCtl.br_eq = false;
            }

            if (reg_data.contents1 < reg_data.contents2) {
                datToCtl.br_lt = true;
            } else {
                datToCtl.br_lt = false;
            }

            if (reg_data.contents1U < reg_data.contents2U) {
                datToCtl.br_ltu = true;
            } else {
                datToCtl.br_ltu = false;
            }

            // provide data to control
            ctlOut->write(datToCtl);

            // read data from control
            ctlIn->read(ctl);

            if (ctl.op1_sel == OP1_RS1) {
                alu_op1 = reg_data.contents1;
            } else if (ctl.op1_sel == OP1_IMU) {
                alu_op1 = decodedInstr.imm_u_sext;
            } else if (ctl.op1_sel == OP1_IMZ) {
                alu_op1 = decodedInstr.imm_z;
            } else {
                alu_op1 = 0;
            }


            if (ctl.op2_sel == OP2_RS2) {
                alu_op2 = reg_data.contents2;
                alu_shamt = reg_data.contents2_shamt;
            } else if (ctl.op2_sel == OP2_PC) {
                alu_op2 = pc_reg;
/*
FIXME: Is it possible to have this case + ALU use shamt?
       probably no, otherwise need to set alu_shamt to pc_reg[4:0],
       and it complicates stuff for SCAM, so leave like this for now.
*/
            } else if (ctl.op2_sel == OP2_IMI) {
                alu_op2 = decodedInstr.imm_i_sext;
                alu_shamt = decodedInstr.imm_i_sext_shamt;
            } else if (ctl.op2_sel == OP2_IMS) {
                alu_op2 = decodedInstr.imm_s_sext;
                alu_shamt = decodedInstr.imm_s_sext_shamt;
            } else {
                alu_op2 = 0;
                alu_shamt = 0;
            }

#ifdef DEBUG
            std::cout << "@Dpath: Decoded ALU operands: " << alu_op1 << ", " << alu_op2 << std::endl;
#endif

            if (ctl.alu_fun == ALU_ADD) {
                alu_out = alu_op1 + alu_op2;
            } else if (ctl.alu_fun == ALU_SUB) {
                alu_out = alu_op1 - alu_op2;
            } else if (ctl.alu_fun == ALU_AND) {
                alu_out = alu_op1 & alu_op2;
            } else if (ctl.alu_fun == ALU_OR) {
                alu_out = alu_op1 | alu_op2;
            } else if (ctl.alu_fun == ALU_XOR) {
                alu_out = alu_op1 ^ alu_op2;
            } else if (ctl.alu_fun == ALU_SLT) {
                if (alu_op1 < alu_op2) {
                    alu_out = 1;
                } else {
                    alu_out = 0;
                }
            } else if (ctl.alu_fun == ALU_SLTU) {
                std::cout << "@Dpath: NOT YET IMPLEMENTED!!!!!\n";
            } else if (ctl.alu_fun == ALU_SRA) {
                std::cout << "@Dpath: NOT YET IMPLEMENTED!!!!!\n";
            } else if (ctl.alu_fun == ALU_SRL) {
                std::cout << "@Dpath: NOT YET IMPLEMENTED!!!!!\n";
            } else if (ctl.alu_fun == ALU_COPY1) {
                alu_out = alu_op1;
            }

            std::cout << "@Dpath: ALU output: " << alu_out << std::endl;
/*
FIXME: Missing CSR exception check.
*/
            if (ctl.wb_sel == WB_ALU) {
                wb_data = alu_out;
            } else if (ctl.wb_sel == WB_MEM) {
                //io.dmem.resp.bits.data,
            } else if (ctl.wb_sel == WB_PC4) {
                wb_data = pc_reg + 4;
            } else if (ctl.wb_sel == WB_CSR) {
                //csr.io.rw.rdata
            }

            if (ctl.rf_wen == true && decodedInstr.rd_addr != 0 /* && !io.dat.csr_xcpt */) {
                reg_req.dst = decodedInstr.rd_addr;
                reg_req.dst_data = wb_data;
                reg_req.req = RegInput::REG_WR;

                reg_out->write(reg_req);
            }

            br_target = pc_reg + decodedInstr.imm_b_sext;
            jmp_target = pc_reg + decodedInstr.imm_j_sext;
            jump_reg_target = reg_data.contents1U + decodedInstr.imm_i_sextU;


            if (ctl.pc_sel == PC_4) {
                pc_next = pc_reg + 4;
            } else if (ctl.pc_sel == PC_BR) {
                pc_next = br_target;
            } else if (ctl.pc_sel == PC_J) {
                pc_next = jmp_target;
            } else if (ctl.pc_sel == PC_JR) {
                pc_next = jump_reg_target;
            } else if (ctl.pc_sel == PC_EXC) {
/*
FIXME: this case is for exception_target, to calculate it CSR needed.
*/
            }

            if (ctl.stall == false) {
                pc_reg = pc_next;
            }


            wait(SC_ZERO_TIME);
        }
    }
};


#endif //PROJECT_DPATH_H
