//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 13.10.18.
//

#ifndef ECALLHANDLER_H
#define ECALLHANDLER_H

#include "systemc"
#include "Interfaces.h"
#include "CPU_Interfaces.h"
#include "../../../RISCV_commons/Memory_Interfaces.h"

#define SYS_write 64 // 0x00000040
#define SYS_exit 93 // 0x0000005D

// Adjusts code to be appropriate for the SCAM tool
// Working ESL-Description -> //#define SCAM
// Properties can be generated -> #define SCAM
//#define SCAM

struct ECallHandler: sc_module {
    // ports for communication with memory
    blocking_out<CUtoME_IF> toMemoryPort;
    blocking_in<MEtoCU_IF> fromMemoryPort;

    // ports for communication with register file
    master_out<RegfileWriteType> ecall_reg_Port;
    master_in<RegfileECallType> reg_ecall_Port;

    // ports for communication with isa
    blocking_in<bool> isa_ecall_Port;
    blocking_out<bool> ecall_isa_Port;

    // data for communication with memory
    CUtoME_IF memoryAccess;
    MEtoCU_IF fromMemoryData;

    // data for communication with register file
    RegfileWriteType regfileWrite;
    RegfileECallType regfileSyscall;

    // data for communication with isa
    bool isaREQ;
    bool sysRES;


    // ISA sections
    enum Sections {
        idle,           // while there is no request from isa
        process,        // process received request from isa
        writing         // read characters from memory and write them to terminal
    };
    Sections section, nextsection;

    unsigned int index;
    unsigned int ans;

    SC_CTOR(ECallHandler) :
            toMemoryPort("toMemoryPort"),
            fromMemoryPort("fromMemoryPort"),
            ecall_reg_Port("ecall_reg_Port"),
            reg_ecall_Port("reg_ecall_Port"),
            isa_ecall_Port("isa_ecall_Port"),
            ecall_isa_Port("ecall_isa_Port"),
            section(idle),
            nextsection(idle),
            index(0),
            ans(0),
            isaREQ(false),
            sysRES(false) {
        SC_THREAD(run);
    }

    /*
    long syscall(long num, long arg0, long arg1, long arg2)
  {
      register long a7 asm("a7") = num;
      register long a0 asm("a0") = arg0;
      register long a1 asm("a1") = arg1;
      register long a2 asm("a2") = arg2;
      asm volatile ("scall":"+r"(a0) : "r"(a1), "r"(a2), "r"(a7));
      return a0;
  }   */
    void run();

};

void ECallHandler::run() {
    while (true) {

        if (section == Sections::idle) {
            isa_ecall_Port->read(isaREQ);

            nextsection = Sections::process;
        }
        if (section == Sections::process) {
            // read arguments
#ifndef SCAM
            // need to make sure that previous instructions have been fully executed and what values are being read from the registerfile are the very recent ones.
            wait(SC_ZERO_TIME);
#endif
            reg_ecall_Port->read(regfileSyscall);
            if (regfileSyscall.reg_file_17 == SYS_exit) {
                // return to isa
                sysRES = false;
                ecall_isa_Port->write(sysRES);

                nextsection = Sections::idle;
            } else if (regfileSyscall.reg_file_17 == SYS_write) {
                ans = regfileSyscall.reg_file_12;
                index = 0;
                nextsection = Sections::writing;
            } else {
                // return to isa
                sysRES = true;
                ecall_isa_Port->write(sysRES);

                nextsection = Sections::idle;
            }
        }
        if (section == Sections::writing) {
            if ( index < regfileSyscall.reg_file_12) {
                // Set up memory access
                memoryAccess.req = ME_RD;
                memoryAccess.mask = MT_BU; // reading a char
                memoryAccess.addrIn = regfileSyscall.reg_file_11 + index; // a1 + index
                memoryAccess.dataIn = 0;    // not relevant

                toMemoryPort->write(memoryAccess); //Send request to memory

                fromMemoryPort->read(fromMemoryData); //Read encoded instruction from memory

#ifndef SCAM
                std::cout<< (char) fromMemoryData.loadedData;
#endif
                index = index + 1;

                nextsection = Sections::writing;

            } else { // done writing
                // write back the answer to register file
                regfileWrite.dst = 0; // not relevant
                regfileWrite.dstData = ans;
                ecall_reg_Port->write(regfileWrite); //Perform write back

                // return to isa
                sysRES = true;
                ecall_isa_Port->write(sysRES);

                nextsection = Sections::idle;

            }
        }
        section = nextsection; // Set next section
    }
}

#endif
