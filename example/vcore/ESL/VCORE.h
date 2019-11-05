//
// Created by ludwig on 10.10.17.
//

#ifndef PROJECT_VCORE_H_H
#define PROJECT_VCORE_H_H

#include "systemc.h"
#include "../Interfaces/Interfaces.h"
#include "types.h"

#define OPCODE_FIELD(x) (x >> 11)

enum class OPCODE {
    UNKNOWN, NOP
};

struct MemReq {
    unsigned addr;
    unsigned data;
    bool write;
};


struct VCORE : public sc_module {
    master_in<unsigned int> instr_in;
    master_out<unsigned int> instr_req;

    master_in<unsigned int[8]> reg_in;
    master_out<RegWrite> reg_out;

    //DATA
    blocking_out<MemReq> mem_write;
    shared_in<unsigned> mem_read;


    //Constructor
    SC_HAS_PROCESS(VCORE);

    VCORE(sc_module_name name) :
            instr_in("instr_in"),
            instr_req("instr_out"),
            from_reset(true),
            phase(rst),
            nextphase(rst) {
        SC_THREAD(fsm);
    }

    bool from_reset;


    unsigned int instr;

    unsigned int pc;
    unsigned int dec_pc;
    unsigned int regfile[8];
    RegWrite regWrite;
    MemReq memRequest;
    unsigned int ex_result;
    unsigned int ex_dest_reg;
    unsigned int ex_op_a;
    unsigned int ex_op_b;

    unsigned int tmp;

    bool branch;
    enum Phases {
        rst, run
    };
    Phases phase, nextphase;

    bool ex_write_reg;

    unsigned getOpCode(unsigned instr) const {
        return OPCODE_FIELD(instr);
    }

    unsigned getDest(unsigned instr) const {
        /*
        case inst(15 downto 11) is
        when 4 => inst(10 downto 8);
        when 6 => inst(10 downto 8);
        when 0 => inst(4 downto 2);
        when 1 => inst(4 downto 2);
        when 2 => inst(4 downto 2);
        when others => prev(ex_dest_reg);
        end case;
         */
        if (getOpCode(instr) == 4) {
            return (instr >> 8) & 7;
        } else return (instr >> 2) & 7;
        //inst(10 downto 8);

    }

    unsigned int pc_old;

    unsigned getOpA(unsigned instr) const {
        //inst(10 downto 8);
        return (instr >> 8) & 7;
    }

    unsigned getOpB(unsigned instr) const {
        //inst(10 downto 8);
        return (instr >> 5) & 7;
    }

    unsigned int getImm(unsigned int instr) const {
        //TODO adjust imm for beqez
        return instr & 4;
    }


    void fsm() {
        //INIT:
        while (true) {
            if (from_reset) {
                instr_in->master_read(instr);
                instr_req->master_write(2);
                //dec_pc = dec_pc + 2;
            }
            from_reset = false;
            //FETCH & DEC
            wait(WAIT_TIME, SC_PS);
            instr_in->master_read(instr);
            pc_old = dec_pc;
            dec_pc = dec_pc + 2;

            instr_req->master_write(dec_pc + 2);
            //EXEC & MEM
            //if(getOpCode(instr) != 4) wait(WAIT_TIME, SC_PS);
            branch = false;
            if (getOpCode(instr) == 0) {
                //NOT
                reg_in->master_read(regfile);
                ex_write_reg = true;
                ex_dest_reg = getDest(instr);
                ex_op_a = getOpA(instr);
                ex_result = ~regfile[ex_op_a];
            } else if (getOpCode(instr) == 1) {
                //ADD
                reg_in->master_read(regfile);
                ex_write_reg = true;
                ex_dest_reg = getDest(instr);
                ex_op_a = regfile[getOpA(instr)];
                ex_op_b = regfile[getOpB(instr)];
                ex_result = ex_op_a + ex_op_b;
            } else if (getOpCode(instr) == 2) {
                //SUB
                reg_in->master_read(regfile);
                ex_write_reg = true;
                ex_dest_reg = getDest(instr);
                ex_op_a = regfile[getOpA(instr)];
                ex_op_b = regfile[getOpB(instr)];
                ex_result = ex_op_a - ex_op_b;
            } else if (getOpCode(instr) == 4) {
                //LOAD
                memRequest.addr = regfile[getOpB(instr)] + getImm(instr);
                memRequest.write = false;
                ex_write_reg = true;
                ex_dest_reg = getDest(instr);
                mem_write->write(memRequest);
                mem_read->get(tmp);
            } else if (getOpCode(instr) == 6) {
                //STORE
                memRequest.addr = regfile[getOpB(instr)] + getImm(instr);
                memRequest.data = regfile[getOpA(instr)];
                memRequest.write = true;
                ex_write_reg = false;
                mem_write->write(memRequest);
            } else if (getOpCode(instr) == 7) {
                //Branch
                reg_in->master_read(regfile);
                //if(regfile[getOpA(instr)] == 0){
                tmp = regfile[getOpA(instr)];
                if (tmp == 0) {
                    branch = true;
                    ex_op_b = getImm(instr);
                } else dec_pc = dec_pc + 2;
                ex_write_reg = false;
            } else {
                //NOP
                ex_write_reg = false;
            }
            //WB
            if (ex_write_reg) {
                if (getOpCode(instr) != 4) {
                    //Additional state required
                    wait(WAIT_TIME, SC_PS);
                    regWrite.dest = ex_dest_reg;
                    regWrite.value = ex_result;
                    reg_out->master_write(regWrite);
                } else {
                    regWrite.dest = ex_dest_reg;
                    regWrite.value = tmp;
                    reg_out->master_write(regWrite);
                }
            } else {
                if (branch) {
                    wait(WAIT_TIME, SC_PS);
                    dec_pc = dec_pc + ex_op_b;
                }
            }
            //DONE
            wait(WAIT_TIME, SC_PS);

        }

    }


};

#endif //PROJECT_SLAVEDAVEBAVE_H_H
