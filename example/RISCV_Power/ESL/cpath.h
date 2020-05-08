//
// Created by ludwig on 08.12.16.
//

#ifndef PROJECT_CPATH_H
#define PROJECT_CPATH_H

#include "systemc.h"
#include "Interfaces.h"
#include "CPU_Interfaces.h"
#include "Utilities.h"
#include "Defines.h"

// Adjusts code to be appropriate for the SCAM tool
// 0 : Working ESL-Description
// 1 : Properties can be generated
#define SCAM 1

class Cpath : public sc_module {
public:
    //Constructor
    SC_HAS_PROCESS(Cpath);

    Cpath(sc_module_name name) :
            MemToCtl_port("store/load_done"),
            CtlToMem_port("to_memory"),
            CtlToDec_port("encoded_instruction"),
            DecToCtl_port("decoded_instruction"),
            CtlToRegs_port("CtlToRegs_port"),
            RegsToCtl_port("RegsToCtl_port"),
            CtlToALU_port("CtlToALU_port"),
            ALUtoCtl_port("ALUtoCtl_port"),
            section(Phases::fetch),
            nextsection(Phases::fetch),
            pc_reg(0),
            pc_next(0),
            pc_sel(PCselType::PC_4),
            fromMemoryData(0),
            reg_rd_en(false),
            wb_en(false),
            mem_en(false),
            br_en(false),
            var(false){
        SC_THREAD(run);
    }

    // ports for communication with memory/decoder
    blocking_out<MemoryAccess> CtlToMem_port;
    blocking_in<unsigned int> MemToCtl_port;
    
    // ports for communication with decoder
    master_out<unsigned int> CtlToDec_port;
    master_in<DecodedInstr> DecToCtl_port;

    // ports for communication with register file
    master_in<RegsToCtl_IF> RegsToCtl_port;
    master_out<CtlToRegs_IF> CtlToRegs_port;

    // ports for communication with ALU
    master_out<CtlToALU_IF> CtlToALU_port;
    master_in<ALUtoCtl_IF> ALUtoCtl_port;

#if SCAM == 1
    master_in<bool> clk;
#endif

    // data for communication with memory
    MemoryAccess memoryAccess;
    unsigned int fromMemoryData;

    // data for communication with decoder
    unsigned int encodedInstr;
    DecodedInstr decodedInstr;

    // data for communication with register file
    CtlToRegs_IF CtlToRegs_data;
    RegsToCtl_IF RegsToCtl_data;

    // data for communication with ALU
    CtlToALU_IF CtlToALU_data;
    ALUtoCtl_IF ALUtoCtl_data;

    // cpath sections
    enum Phases {
        fetch,              // fetch next instruction from memory
        decode,             // send encoded instruction to decoder and receive decoded instruction
        setControl,         // set up control signals for: regfile read, ALU, bran. and jumps, stores/loads, regfile wb
        readRegisterFile,   // read register file data
        executeALU,         // execute ALU operation
        calculateNextPC,    // resolves branches, calculates next PC
        memoryOperation,    // perform stores and loads
        writeBack           // performs register write back
    };
    Phases section, nextsection;

    // PC register
    unsigned int pc_reg;
    // next PC value
    unsigned int pc_next;

    // Other control signals:

    // register read enable
    bool reg_rd_en;

    // branch calculation enable
    bool br_en;

    // pc select
    PCselType pc_sel;

    // memory access enable (load/store)
    bool mem_en;

    // write back enable
    bool wb_en;

    // write back select
    WBselType wb_sel;

    // write back data
    unsigned int wb_data;

    bool var;

    // thread
    void run();
};


void Cpath::run() {

    while (true) {

        section = nextsection;

        // fetch next instruction and acquire decoded instruction from Decoder
        if (section == Phases::fetch){
            // Set up memory access
            memoryAccess.addrIn = pc_reg;
            memoryAccess.dataIn = 0;    // not relevant
            memoryAccess.mask = MT_W; // always for instructions
            memoryAccess.req = MEM_READ;

            //Send request to memory
            CtlToMem_port->write(memoryAccess);
            //Read decoded instruction from decoder
            MemToCtl_port->read(encodedInstr);

            // Terminate if:
            // Zero instruction is read
#if SCAM == 0
            if (encodedInstr == 0x0) {
                cout << "@CTL: End of program... Terminating!" << endl;
                sc_stop();
                wait(SC_ZERO_TIME);
            }
#endif

            nextsection = Phases::decode;
        }
        if (section == Phases::decode){

            // Send encoded instruction to decoder
            CtlToDec_port->master_write(encodedInstr);

#if SCAM == 1
            clk->master_read(var);
            clk->master_read(var);
#endif


            // Receive decoded instruction
            DecToCtl_port->master_read(decodedInstr);

            nextsection = Phases::setControl;
        }

        // set up control signals for:
        // regfile read, ALU operation, branching and jumping, stores/loads, regfile write back
        if (section == Phases::setControl) {

            if (decodedInstr.encType == I) {

                if (decodedInstr.instrType == InstrType::addI || decodedInstr.instrType == InstrType::sltI ||
                    decodedInstr.instrType == InstrType::sltIu || decodedInstr.instrType == InstrType::xorI ||
                    decodedInstr.instrType == InstrType::orI || decodedInstr.instrType == InstrType::andI ||
                    decodedInstr.instrType == InstrType::sllI || decodedInstr.instrType == InstrType::srlI ||
                    decodedInstr.instrType == InstrType::sraI) { // arithmetics

                    // common for arithmetics
                    CtlToALU_data.op1_sel = OP_REG;
                    CtlToALU_data.op2_sel = OP_IMM;
                    wb_sel = WBselType::WB_ALU;
                    wb_en = true;
                    reg_rd_en = true;
                    mem_en = false;
                    br_en = false;

                    // set ALU function
                    if (decodedInstr.instrType == InstrType::addI) {
                        CtlToALU_data.alu_fun = ALU_ADD;
                    } else if (decodedInstr.instrType == InstrType::sltI) {
                        CtlToALU_data.alu_fun = ALU_SLT;
                    } else if (decodedInstr.instrType == InstrType::sltIu) {
                        CtlToALU_data.alu_fun = ALU_SLTU;
                    } else if (decodedInstr.instrType == InstrType::xorI) {
                        CtlToALU_data.alu_fun = ALU_XOR;
                    } else if (decodedInstr.instrType == InstrType::orI) {
                        CtlToALU_data.alu_fun = ALU_OR;
                    } else if (decodedInstr.instrType == InstrType::andI) {
                        CtlToALU_data.alu_fun = ALU_AND;
                    } else if (decodedInstr.instrType == InstrType::sllI) {
                        CtlToALU_data.alu_fun = ALU_SLL;
                    } else if (decodedInstr.instrType == InstrType::srlI) {
                        CtlToALU_data.alu_fun = ALU_SRL;
                    } else if (decodedInstr.instrType == InstrType::sraI) {
                        CtlToALU_data.alu_fun = ALU_SRA;
                    }
                } else if (decodedInstr.instrType == InstrType::lb || decodedInstr.instrType == InstrType::lh ||
                           decodedInstr.instrType == InstrType::lw || decodedInstr.instrType == InstrType::lbu ||
                           decodedInstr.instrType == InstrType::lhu) { // loads

                    // common for loads
                    CtlToALU_data.op1_sel = OP_REG;
                    CtlToALU_data.op2_sel = OP_IMM;
                    CtlToALU_data.alu_fun = ALU_ADD;
                    wb_sel = WBselType::WB_MEM;
                    wb_en = true;
                    reg_rd_en = true;
                    mem_en = true;
                    br_en = false;

                    // set memory access
                    memoryAccess.req = MEM_READ;

                    // set memory mask
                    if (decodedInstr.instrType == InstrType::lb) {
                        memoryAccess.mask = MT_B;
                    } else if (decodedInstr.instrType == InstrType::lh) {
                        memoryAccess.mask = MT_H;
                    } else if (decodedInstr.instrType == InstrType::lw) {
                        memoryAccess.mask = MT_W;
                    } else if (decodedInstr.instrType == InstrType::lbu) {
                        memoryAccess.mask = MT_BU;
                    } else if (decodedInstr.instrType == InstrType::lhu) {
                        memoryAccess.mask = MT_HU;
                    }

                } else if (decodedInstr.instrType == InstrType::jalr) {
                    // jalr
                    CtlToALU_data.op1_sel = OP_X;  //check
                    CtlToALU_data.op2_sel = OP_X;  //check
                    CtlToALU_data.alu_fun = ALU_X;
                    wb_sel = WBselType::WB_PC4;  //important
                    wb_en = true;
                    reg_rd_en = true;
                    mem_en = false;
                    br_en = false;
                }

            } else if (decodedInstr.encType == R) {

                // common for all r type
                CtlToALU_data.op1_sel = OP_REG;
                CtlToALU_data.op2_sel = OP_REG;
                wb_sel = WBselType::WB_ALU;
                wb_en = true;
                reg_rd_en = true;
                mem_en = false;
                br_en = false;

                // set ALU function:
                if (decodedInstr.instrType == InstrType::add) {
                    CtlToALU_data.alu_fun = ALU_ADD;
                } else if (decodedInstr.instrType == InstrType::sub) {
                    CtlToALU_data.alu_fun = ALU_SUB;
                } else if (decodedInstr.instrType == InstrType::sll_Instr) {
                    CtlToALU_data.alu_fun = ALU_SLL;
                } else if (decodedInstr.instrType == InstrType::slt) {
                    CtlToALU_data.alu_fun = ALU_SLT;
                } else if (decodedInstr.instrType == InstrType::sltu) {
                    CtlToALU_data.alu_fun = ALU_SLTU;
                } else if (decodedInstr.instrType == InstrType::Xor_Instr) {
                    CtlToALU_data.alu_fun = ALU_XOR;
                } else if (decodedInstr.instrType == InstrType::srl_Instr) {
                    CtlToALU_data.alu_fun = ALU_SRL;
                } else if (decodedInstr.instrType == InstrType::sra_Instr) {
                    CtlToALU_data.alu_fun = ALU_SRA;
                } else if (decodedInstr.instrType == InstrType::Or_Instr) {
                    CtlToALU_data.alu_fun = ALU_OR;
                } else if (decodedInstr.instrType == InstrType::And_Instr) {
                    CtlToALU_data.alu_fun = ALU_AND;
                } 


            } else if (decodedInstr.encType == B) {
                // common for all B type (conditional branches)
                CtlToALU_data.op1_sel = OP_REG;
                CtlToALU_data.op2_sel = OP_REG;
                wb_sel = WBselType::WB_X;
                reg_rd_en = true;
                wb_en = false;
                mem_en = false;
                br_en = true;

                // set ALU function
                // beq/bne use ALU_SUB, blt,bge use ALU_SLT, bltu,bgeu use ALU_SLTU
                if (decodedInstr.instrType == InstrType::beq) {
                    CtlToALU_data.alu_fun = ALU_SUB;
                } else if (decodedInstr.instrType == InstrType::bne) {
                    CtlToALU_data.alu_fun = ALU_SUB;
                } else if (decodedInstr.instrType == InstrType::blt) {
                    CtlToALU_data.alu_fun = ALU_SLT;
                } else if (decodedInstr.instrType == InstrType::bge) {
                    CtlToALU_data.alu_fun = ALU_SLT;
                } else if (decodedInstr.instrType == InstrType::bltu) {
                    CtlToALU_data.alu_fun = ALU_SLTU;
                } else if (decodedInstr.instrType == InstrType::bgeu) {
                    CtlToALU_data.alu_fun = ALU_SLTU;
                }
            } else if (decodedInstr.encType == J) {
                // only jal
                if (decodedInstr.instrType == InstrType::jal) {
                    CtlToALU_data.op1_sel = OP_X;
                    CtlToALU_data.op2_sel = OP_X;
                    CtlToALU_data.alu_fun = ALU_X;
                    wb_sel = WBselType::WB_PC4;
                    reg_rd_en = false; // no register is read in jal
                    wb_en = true;
                    mem_en = false;
                    br_en = false;
                }
            } else if (decodedInstr.encType == S) {
                // common for all stores
                CtlToALU_data.op1_sel = OP_REG;  // rs1 = base reg
                CtlToALU_data.op2_sel = OP_IMM;  // offset
                CtlToALU_data.alu_fun = ALU_ADD;
                wb_sel = WBselType::WB_X;
                wb_en = false;
                reg_rd_en = true;
                mem_en = true;
                br_en = false;

                // set memory access
                memoryAccess.req = MEM_WRITE;

                // set memory access mask
                if (decodedInstr.instrType == InstrType::sb) {
                    memoryAccess.mask = MT_B;
                } else if (decodedInstr.instrType == InstrType::sh) {
                    memoryAccess.mask = MT_H;
                } else if (decodedInstr.instrType == InstrType::sw) {
                    memoryAccess.mask = MT_W;
                }

            } else if (decodedInstr.encType == U) {

                wb_sel = WBselType::WB_ALU;
                wb_en = true;
                reg_rd_en = false;  // no regs read for lui, auipc
                mem_en = false;
                br_en = false;

                if (decodedInstr.instrType == InstrType::lui) {
                    CtlToALU_data.op1_sel = OP_IMM;
                    CtlToALU_data.op2_sel = OP_X;
                    CtlToALU_data.alu_fun = ALU_COPY1;
                } else if (decodedInstr.instrType == InstrType::auipc) {
                    CtlToALU_data.op1_sel = OP_PC;
                    CtlToALU_data.op2_sel = OP_IMM;
                    CtlToALU_data.alu_fun = ALU_ADD;
                }

            }

            nextsection = Phases::readRegisterFile;
        }

        // read register file data
        if (section == Phases::readRegisterFile){

            if (reg_rd_en) {
                // Read from reg file request
                CtlToRegs_data.src1 = decodedInstr.rs1_addr;
                CtlToRegs_data.src2 = decodedInstr.rs2_addr;
                CtlToRegs_data.req = REG_RD;

                // Request register data
                CtlToRegs_port->master_write(CtlToRegs_data);

#if SCAM == 1
                clk->master_read(var);
#endif

                // Get requested data
                RegsToCtl_port->master_read(RegsToCtl_data);
            }

            nextsection = Phases::executeALU;
        }

        // execute ALU operation
        if (section == Phases::executeALU) {

            // set ALU input data
            CtlToALU_data.reg1_contents = RegsToCtl_data.contents1;
            CtlToALU_data.reg2_contents = RegsToCtl_data.contents2;
            CtlToALU_data.imm = decodedInstr.imm;
            CtlToALU_data.pc_reg = pc_reg;

            // Program the ALU....
            CtlToALU_port->master_write(CtlToALU_data);

#if SCAM == 1
            clk->master_read(var);
            clk->master_read(var);
#endif


            //Read ALU results....
            ALUtoCtl_port->master_read(ALUtoCtl_data);

            nextsection = calculateNextPC;
        }

        // calculate next PC value (branch, jump or advance)
        if (section == calculateNextPC){

            pc_sel = PCselType::PC_4;  // default

            // resolve branches
            if (br_en) {
                if (decodedInstr.instrType == InstrType::beq && ALUtoCtl_data.ALU_result == 0) {
                    pc_sel = PCselType::PC_BR;
                } else if (decodedInstr.instrType == InstrType::bne && ALUtoCtl_data.ALU_result != 0) {
                    pc_sel = PCselType::PC_BR;
                } else if (decodedInstr.instrType == InstrType::blt && ALUtoCtl_data.ALU_result == 1) {
                    pc_sel = PCselType::PC_BR;
                } else if (decodedInstr.instrType == InstrType::bge && ALUtoCtl_data.ALU_result == 0) {
                    pc_sel = PCselType::PC_BR;
                } else if (decodedInstr.instrType == InstrType::bltu && ALUtoCtl_data.ALU_result == 1) {
                    pc_sel = PCselType::PC_BR;
                } else if (decodedInstr.instrType == InstrType::bgeu && ALUtoCtl_data.ALU_result == 0) {
                    pc_sel = PCselType::PC_BR;
                }
            }

            // set jumps
            if (decodedInstr.instrType == InstrType::jal) {
                pc_sel = PCselType::PC_J;
            } else if (decodedInstr.instrType == InstrType::jalr) {
                pc_sel = PCselType::PC_JR;
            }

            // calculate new PC value
            if (pc_sel == PCselType::PC_4) {
                pc_next = pc_reg + 4;
            } else if (pc_sel == PCselType::PC_BR) {
                pc_next = pc_reg + decodedInstr.imm;
            } else if (pc_sel == PCselType::PC_J) {
                pc_next = pc_reg + decodedInstr.imm;
            } else if (pc_sel == PCselType::PC_JR) {
                pc_next = RegsToCtl_data.contents1 + decodedInstr.imm;
            } else if (pc_sel == PCselType::PC_EXC) {
                // FIXME: this case is for exception_target, to calculate it CSR needed.
            }

            nextsection = Phases::memoryOperation;
        }

        // perform stores and loads
        if (section == Phases::memoryOperation){

            if (mem_en) {

                // memoryAccess.req and memoryAccess.mask already set in control

                // Set address (ALU result) for loads and stores
                memoryAccess.addrIn = ALUtoCtl_data.ALU_result;

                // Set data for stores (not relevant for loads)
                memoryAccess.dataIn = RegsToCtl_data.contents2;    // rs2 = source for store


#ifdef DEBUG
                cout << "@Cpath: Store/Load at location 0x" << hex << memoryAccess.addrIn << endl;
#endif

                // Request load/store
                CtlToMem_port->write(memoryAccess);

                // Load/store done
                MemToCtl_port->read(fromMemoryData);
            }

            nextsection = Phases::writeBack;
        }

        // perform register write back
        if (section == Phases::writeBack){

            // Set Write Back data
            if (wb_sel == WBselType::WB_ALU) {
                wb_data = ALUtoCtl_data.ALU_result;
            } else if (wb_sel == WBselType::WB_MEM) {
                wb_data = fromMemoryData;
            } else if (wb_sel == WBselType::WB_PC4) {
                wb_data = pc_reg + 4;
            }

            // Perform Register File Write Back
            if (wb_en == true && wb_sel != WBselType::WB_X && decodedInstr.rd_addr != 0) {
                CtlToRegs_data.dst = decodedInstr.rd_addr;
                CtlToRegs_data.dst_data = wb_data;
                CtlToRegs_data.req = REG_WR;
                // request write back to register file
                CtlToRegs_port->master_write(CtlToRegs_data);
            }

            // set new PC value
            pc_reg = pc_next;

            // set next section
            nextsection = Phases::fetch;
        }

        // set next section
        section = nextsection;

    }

}


#endif //PROJECT_CPATH_H
