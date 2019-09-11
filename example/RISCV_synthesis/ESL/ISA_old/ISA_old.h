//
// Created by PauliusMorku on 06.14.18.
//

#ifndef RISCV_ISA_H_
#define RISCV_ISA_H_

#include "systemc.h"
#include "Interfaces.h"
#include "CPU_Interfaces.h"
#include "../../../RISCV_commons/Utilities.h"
#include "../../../RISCV_commons/Memory_Interfaces.h"


class ISA : public sc_module {
public:
    //Constructor
    SC_HAS_PROCESS(ISA);

    ISA(sc_module_name name) :
            MemToCtl_port("store/load_done"),
            CtlToMem_port("to_memory"),
            CtlToDec_port("encoded_instruction"),
            DecToCtl_port("decoded_instruction"),
            CtlToRegs_port("CtlToRegs_port"),
            RegsToCtl_port("RegsToCtl_port"),
            section(Sections::fetch),
            nextsection(Sections::fetch),
            pc_reg(0),
            pc_next(0),
            pc_sel(PCselType::PC_4),
            fromMemoryData(0),
            reg_rd_en(false),
            wb_en(false),
            mem_en(false),
            br_en(false),
            dummy(false) {
        SC_THREAD(run);
    }

    // ports for communication with memory/decoder
    blocking_out<CUtoME_IF> CtlToMem_port;
    blocking_in<MEtoCU_IF> MemToCtl_port;

    // ports for communication with register file
    blocking_in<RegsToCtl_IF> RegsToCtl_port;
    blocking_out<CtlToRegs_IF> CtlToRegs_port;

    // ports for communication with decoder
    blocking_out<unsigned int> CtlToDec_port;
    blocking_in<DecodedInstr> DecToCtl_port;


    // data for communication with memory
    CPtoME_IF memoryAccess;
    MEtoCP_IF fromMemory;
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
    enum Sections {
        fetch,              // fetch next instruction from memory
        decode,             // send encoded instruction to decoder and receive decoded instruction
        setControl,         // set up control signals for: regfile read, ALU, bran. and jumps, stores/loads, regfile wb
        readRegisterFile,   // read register file data
        executeALU,         // execute ALU operation
        calculateNextPC,    // resolves branches, calculates next PC
        memoryOperation,    // perform stores and loads
        writeBack           // performs register write back
    };
    Sections section, nextsection;

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

    bool dummy;

    // ALU operands
    unsigned int alu_op1;
    unsigned int alu_op2;


    // thread
    void run();
};


void ISA::run() {

    while (true) {

        //<editor-fold desc="Section: fetch">
        // fetch next instruction and acquire decoded instruction from Decoder
        if (section == Sections::fetch) {
            // Set up memory access
            memoryAccess.addrIn = pc_reg;
            //memoryAccess.dataIn = 0;    // not relevant
            memoryAccess.mask = ME_MaskType::MT_W; // always for instructions
            memoryAccess.req = ME_AccessType::ME_RD;

            //Send request to memory
            CtlToMem_port->write(memoryAccess);

            //Read decoded instruction from decoder
            MemToCtl_port->read(fromMemory);
            encodedInstr = fromMemory.loadedData;

            nextsection = Sections::decode;
        }
        //</editor-fold>

        //<editor-fold desc="Section: decode">
        if (section == Sections::decode) {
            // Send encoded instruction to decoder
            CtlToDec_port->write(encodedInstr);

            // Receive decoded instruction
            DecToCtl_port->read(decodedInstr);

            nextsection = Sections::setControl;
        }
        //</editor-fold>

        //<editor-fold desc="Section: setControl">
        // set up control signals for:
        // regfile read, ALU operation, branching and jumping, stores/loads, regfile write back
        if (section == Sections::setControl) {
            if (decodedInstr.encType == I) {
                if (decodedInstr.instrType == InstrType::addI || decodedInstr.instrType == InstrType::sltI ||
                    decodedInstr.instrType == InstrType::sltIu || decodedInstr.instrType == InstrType::xorI ||
                    decodedInstr.instrType == InstrType::orI || decodedInstr.instrType == InstrType::andI ||
                    decodedInstr.instrType == InstrType::sllI || decodedInstr.instrType == InstrType::srlI ||
                    decodedInstr.instrType == InstrType::sraI) { // arithmetics

                    // common for arithmetics
                    CtlToALU_data.op1_sel = CtlToALU_IF::OP_REG;
                    CtlToALU_data.op2_sel = CtlToALU_IF::OP_IMM;
                    wb_sel = WBselType::WB_ALU;
                    wb_en = true;
                    reg_rd_en = true;
                    mem_en = false;
                    br_en = false;

                    // set ALU function
                    if (decodedInstr.instrType == InstrType::addI) {
                        CtlToALU_data.alu_fun = CtlToALU_IF::ALU_ADD;
                    } else if (decodedInstr.instrType == InstrType::sltI) {
                        CtlToALU_data.alu_fun = CtlToALU_IF::ALU_SLT;
                    } else if (decodedInstr.instrType == InstrType::sltIu) {
                        CtlToALU_data.alu_fun = CtlToALU_IF::ALU_SLTU;
                    } else if (decodedInstr.instrType == InstrType::xorI) {
                        CtlToALU_data.alu_fun = CtlToALU_IF::ALU_XOR;
                    } else if (decodedInstr.instrType == InstrType::orI) {
                        CtlToALU_data.alu_fun = CtlToALU_IF::ALU_OR;
                    } else if (decodedInstr.instrType == InstrType::andI) {
                        CtlToALU_data.alu_fun = CtlToALU_IF::ALU_AND;
                    } else if (decodedInstr.instrType == InstrType::sllI) {
                        CtlToALU_data.alu_fun = CtlToALU_IF::ALU_SLL;
                    } else if (decodedInstr.instrType == InstrType::srlI) {
                        CtlToALU_data.alu_fun = CtlToALU_IF::ALU_SRL;
                    } else if (decodedInstr.instrType == InstrType::sraI) {
                        CtlToALU_data.alu_fun = CtlToALU_IF::ALU_SRA;
                    }
                } else if (decodedInstr.instrType == InstrType::lb || decodedInstr.instrType == InstrType::lh ||
                           decodedInstr.instrType == InstrType::lw || decodedInstr.instrType == InstrType::lbu ||
                           decodedInstr.instrType == InstrType::lhu) { // loads

                    // common for loads
                    CtlToALU_data.op1_sel = CtlToALU_IF::OP_REG;
                    CtlToALU_data.op2_sel = CtlToALU_IF::OP_IMM;
                    CtlToALU_data.alu_fun = CtlToALU_IF::ALU_ADD;
                    wb_sel = WBselType::WB_MEM;
                    wb_en = true;
                    reg_rd_en = true;
                    mem_en = true;
                    br_en = false;

                    // set memory access
                    memoryAccess.req = ME_AccessType::ME_RD;

                    // set memory mask
                    if (decodedInstr.instrType == InstrType::lb) {
                        memoryAccess.mask = ME_MaskType::MT_B;
                    } else if (decodedInstr.instrType == InstrType::lh) {
                        memoryAccess.mask = ME_MaskType::MT_H;
                    } else if (decodedInstr.instrType == InstrType::lw) {
                        memoryAccess.mask = ME_MaskType::MT_W;
                    } else if (decodedInstr.instrType == InstrType::lbu) {
                        memoryAccess.mask = ME_MaskType::MT_BU;
                    } else if (decodedInstr.instrType == InstrType::lhu) {
                        memoryAccess.mask = ME_MaskType::MT_HU;
                    }

                } else if (decodedInstr.instrType == InstrType::jalr) {
                    // jalr
                    CtlToALU_data.op1_sel = CtlToALU_IF::OP_X;  //check
                    CtlToALU_data.op2_sel = CtlToALU_IF::OP_X;  //check
                    CtlToALU_data.alu_fun = CtlToALU_IF::ALU_X;
                    wb_sel = WBselType::WB_PC4;  //important
                    wb_en = true;
                    reg_rd_en = true;
                    mem_en = false;
                    br_en = false;
                }

            } else if (decodedInstr.encType == R) {

                // common for all R type
                CtlToALU_data.op1_sel = CtlToALU_IF::OP_REG;
                CtlToALU_data.op2_sel = CtlToALU_IF::OP_REG;
                wb_sel = WBselType::WB_ALU;
                wb_en = true;
                reg_rd_en = true;
                mem_en = false;
                br_en = false;

                // set ALU function:
                if (decodedInstr.instrType == InstrType::add) {
                    CtlToALU_data.alu_fun = CtlToALU_IF::ALU_ADD;
                } else if (decodedInstr.instrType == InstrType::sub) {
                    CtlToALU_data.alu_fun = CtlToALU_IF::ALU_SUB;
                } else if (decodedInstr.instrType == InstrType::sll_Instr) {
                    CtlToALU_data.alu_fun = CtlToALU_IF::ALU_SLL;
                } else if (decodedInstr.instrType == InstrType::slt) {
                    CtlToALU_data.alu_fun = CtlToALU_IF::ALU_SLT;
                } else if (decodedInstr.instrType == InstrType::sltu) {
                    CtlToALU_data.alu_fun = CtlToALU_IF::ALU_SLTU;
                } else if (decodedInstr.instrType == InstrType::Xor_Instr) {
                    CtlToALU_data.alu_fun = CtlToALU_IF::ALU_XOR;
                } else if (decodedInstr.instrType == InstrType::srl_Instr) {
                    CtlToALU_data.alu_fun = CtlToALU_IF::ALU_SRL;
                } else if (decodedInstr.instrType == InstrType::sra_Instr) {
                    CtlToALU_data.alu_fun = CtlToALU_IF::ALU_SRA;
                } else if (decodedInstr.instrType == InstrType::Or_Instr) {
                    CtlToALU_data.alu_fun = CtlToALU_IF::ALU_OR;
                } else if (decodedInstr.instrType == InstrType::And_Instr) {
                    CtlToALU_data.alu_fun = CtlToALU_IF::ALU_AND;
                }


            } else if (decodedInstr.encType == B) {
                // common for all B type (conditional branches)
                CtlToALU_data.op1_sel = CtlToALU_IF::OP_REG;
                CtlToALU_data.op2_sel = CtlToALU_IF::OP_REG;
                wb_sel = WBselType::WB_X;
                reg_rd_en = true;
                wb_en = false;
                mem_en = false;
                br_en = true;

                // set ALU function
                // beq/bne use ALU_SUB, blt,bge use ALU_SLT, bltu,bgeu use ALU_SLTU
                if (decodedInstr.instrType == InstrType::beq) {
                    CtlToALU_data.alu_fun = CtlToALU_IF::ALU_SUB;
                } else if (decodedInstr.instrType == InstrType::bne) {
                    CtlToALU_data.alu_fun = CtlToALU_IF::ALU_SUB;
                } else if (decodedInstr.instrType == InstrType::blt) {
                    CtlToALU_data.alu_fun = CtlToALU_IF::ALU_SLT;
                } else if (decodedInstr.instrType == InstrType::bge) {
                    CtlToALU_data.alu_fun = CtlToALU_IF::ALU_SLT;
                } else if (decodedInstr.instrType == InstrType::bltu) {
                    CtlToALU_data.alu_fun = CtlToALU_IF::ALU_SLTU;
                } else if (decodedInstr.instrType == InstrType::bgeu) {
                    CtlToALU_data.alu_fun = CtlToALU_IF::ALU_SLTU;
                }
            } else if (decodedInstr.encType == J) {
                // only jal
                if (decodedInstr.instrType == InstrType::jal) {
                    CtlToALU_data.op1_sel = CtlToALU_IF::OP_X;
                    CtlToALU_data.op2_sel = CtlToALU_IF::OP_X;
                    CtlToALU_data.alu_fun = CtlToALU_IF::ALU_X;
                    wb_sel = WBselType::WB_PC4;
                    reg_rd_en = false; // no register is read in jal
                    wb_en = true;
                    mem_en = false;
                    br_en = false;
                }
            } else if (decodedInstr.encType == S) {
                // common for all stores
                CtlToALU_data.op1_sel = CtlToALU_IF::OP_REG;  // rs1 = base reg
                CtlToALU_data.op2_sel = CtlToALU_IF::OP_IMM;  // offset
                CtlToALU_data.alu_fun = CtlToALU_IF::ALU_ADD;
                wb_sel = WBselType::WB_X;
                wb_en = false;
                reg_rd_en = true;
                mem_en = true;
                br_en = false;

                // set memory access
                memoryAccess.req = ME_AccessType::ME_WR;

                // set memory access mask
                if (decodedInstr.instrType == InstrType::sb) {
                    memoryAccess.mask = ME_MaskType::MT_B;
                } else if (decodedInstr.instrType == InstrType::sh) {
                    memoryAccess.mask = ME_MaskType::MT_H;
                } else if (decodedInstr.instrType == InstrType::sw) {
                    memoryAccess.mask = ME_MaskType::MT_W;
                }

            } else if (decodedInstr.encType == U) {

                wb_sel = WBselType::WB_ALU;
                wb_en = true;
                reg_rd_en = false;  // no regs read for lui, auipc
                mem_en = false;
                br_en = false;

                if (decodedInstr.instrType == InstrType::lui) {
                    CtlToALU_data.op1_sel = CtlToALU_IF::OP_IMM;
                    CtlToALU_data.op2_sel = CtlToALU_IF::OP_X;
                    CtlToALU_data.alu_fun = CtlToALU_IF::ALU_COPY1;
                } else if (decodedInstr.instrType == InstrType::auipc) {
                    CtlToALU_data.op1_sel = CtlToALU_IF::OP_PC;
                    CtlToALU_data.op2_sel = CtlToALU_IF::OP_IMM;
                    CtlToALU_data.alu_fun = CtlToALU_IF::ALU_ADD;
                }

            }

            nextsection = Sections::readRegisterFile;
        }
        //</editor-fold>

        //<editor-fold desc="Section: readRegisterFile">
        // read register file data
        if (section == Sections::readRegisterFile) {

            if (reg_rd_en) {
                // Read from reg file request
                CtlToRegs_data.src1 = decodedInstr.rs1_addr;
                CtlToRegs_data.src2 = decodedInstr.rs2_addr;
                CtlToRegs_data.req = CtlToRegs_IF::REG_RD;

                // Request register data
                CtlToRegs_port->write(CtlToRegs_data);
            }

            nextsection = Sections::executeALU;
        }
        //</editor-fold>

        //<editor-fold desc="Section: executeALU">
        // execute ALU operation
        if (section == Sections::executeALU) {

            // default
            ALUtoCtl_data.ALU_result = 0;

            // select ALU operand 1
            if (CtlToALU_data.op1_sel == CtlToALU_IF::OP_REG) {
                alu_op1 = RegsToCtl_data.contents1;
            } else if (CtlToALU_data.op1_sel == CtlToALU_IF::OP_IMM) {
                alu_op1 = decodedInstr.imm;
            } else if (CtlToALU_data.op1_sel == CtlToALU_IF::OP_PC) {
                alu_op1 = pc_reg;
            } else {
                alu_op1 = 0;
            }

            // select ALU operand 2
            if (CtlToALU_data.op2_sel == CtlToALU_IF::OP_REG) {
                alu_op2 = RegsToCtl_data.contents2;
            } else if (CtlToALU_data.op2_sel == CtlToALU_IF::OP_IMM) {
                alu_op2 = decodedInstr.imm;
            } else if (CtlToALU_data.op2_sel == CtlToALU_IF::OP_PC) {
                alu_op2 = pc_reg;
            } else {
                alu_op2 = 0;
            }

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

            nextsection = calculateNextPC;
        }
        //</editor-fold>

        //<editor-fold desc="Section: calculateNextPC">
        // calculate next PC value (branch, jump or advance)
        if (section == calculateNextPC) {

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

            nextsection = Sections::memoryOperation;
        }
        //</editor-fold>

        //<editor-fold desc="Section: memoryOperation">
        // perform stores and loads
        if (section == Sections::memoryOperation) {

            if (mem_en) {

                // memoryAccess.req and memoryAccess.mask already set in control

                // Set address (ALU result) for loads and stores
                memoryAccess.addrIn = ALUtoCtl_data.ALU_result;

                // Set data for stores (not relevant for loads)
                memoryAccess.dataIn = RegsToCtl_data.contents2;    // rs2 = source for store

                // Request load/store
                CtlToMem_port->write(memoryAccess);

                // Load/store done
                MemToCtl_port->read(fromMemory);
                fromMemoryData = fromMemory.loadedData;
            }

            nextsection = Sections::writeBack;
        }
        //</editor-fold>

        //<editor-fold desc="Section: writeBack">
        // perform register write back
        if (section == Sections::writeBack) {

            // Set Write Back data
            if (wb_sel == WBselType::WB_ALU) {
                wb_data = ALUtoCtl_data.ALU_result;
            } else if (wb_sel == WBselType::WB_MEM) {
                wb_data = fromMemoryData;
                // sign extension for lb and lh
                if (decodedInstr.instrType == InstrType::lb) {
                    // sign extend
                    if (Sub(wb_data, 7, 7) == 1) {
                        wb_data = Cat(Fill(24), 24, wb_data, 8);
                    }
                } else if (decodedInstr.instrType == InstrType::lh) {
                    // sign extend
                    if (Sub(wb_data, 15, 15) == 1) {
                        wb_data = Cat(Fill(16), 16, wb_data, 16);
                    }
                }
            } else if (wb_sel == WBselType::WB_PC4) {
                wb_data = pc_reg + 4;
            }

            // Perform Register File Write Back
            if (wb_en == true && wb_sel != WBselType::WB_X && decodedInstr.rd_addr != 0) {
                CtlToRegs_data.dst = decodedInstr.rd_addr;
                CtlToRegs_data.dst_data = wb_data;
                CtlToRegs_data.req = CtlToRegs_IF::REG_WR;
                // request write back to register file
                CtlToRegs_port->write(CtlToRegs_data);
                // wait for register file write back
                RegsToCtl_port->read(RegsToCtl_data);
            }

            // set new PC value
            pc_reg = pc_next;

            // set next section
            nextsection = Sections::fetch;
        }
        //</editor-fold>

        // Set next section
        section = nextsection;
    }
}


#endif //RISCV_ISA_H_

