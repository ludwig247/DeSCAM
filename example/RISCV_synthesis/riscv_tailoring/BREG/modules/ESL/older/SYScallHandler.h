//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 13.10.18.
//

#ifndef SYSCALLHANDLER_H
#define SYSCALLHANDLER_H

#include "systemc"
#include "Interfaces.h"
#include "CPU_Interfaces.h"
#include "Memory_Interfaces.h"

#define SYS_write 64 // 0x00000040
#define SYS_exit 93 // 0x0000005D

struct SYScallHandler: sc_module {
    // ports for communication with memory
    blocking_out<CUtoME_IF> COtoME_port;
    blocking_in<MEtoCU_IF> MEtoCO_port;

    // ports for communication with register file
    master_out<RegfileWriteType> syscall_reg_Port;
    master_in<RegfileSyscallType> reg_syscall_Port;

    // ports for communication with isa
    blocking_in<bool> isa_syscall_Port;
    blocking_out<bool> syscall_isa_Port;

    // data for communication with memory
    CUtoME_IF memoryAccess;
    MEtoCU_IF fromMemoryData;

    // data for communication with register file
    RegfileWriteType regfileWrite;
    RegfileSyscallType regfileSyscall;

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

    SC_CTOR(SYScallHandler) :
            COtoME_port("COtoME_port"),
            MEtoCO_port("MEtoCO_port"),
            syscall_reg_Port("syscall_reg_Port"),
            reg_syscall_Port("reg_syscall_Port"),
            isa_syscall_Port("isa_syscall_Port"),
            syscall_isa_Port("syscall_isa_Port"),
            section(idle),
            nextsection(idle),
            index(0),
            ans(0),
            isaREQ(false),
            sysRES(false) {
        SC_THREAD(run);
    }
    void run();

};

void SYScallHandler::run() {
    while (true) {

        if (section == Sections::idle) {
            isa_syscall_Port->read(isaREQ);

            nextsection = Sections::process;
        }
        if (section == Sections::process) {
            // read arguments
            reg_syscall_Port->read(regfileSyscall);
            if (regfileSyscall.reg_file_17 == SYS_exit) {
                // return to isa
                sysRES = false;
                syscall_isa_Port->write(sysRES);

                nextsection = Sections::idle;
            } else if (regfileSyscall.reg_file_17 == SYS_write) {
                ans = regfileSyscall.reg_file_12;
                index = 0;
                nextsection = Sections::writing;
            } else {
                // return to isa
                sysRES = true;
                syscall_isa_Port->write(sysRES);

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

                COtoME_port->write(memoryAccess); //Send request to memory

                MEtoCO_port->read(fromMemoryData); //Read encoded instruction from memory

#ifdef SC_SIMULATE
                std::cout<< (char) fromMemoryData.loadedData;
#endif
                index = index + 1;

                nextsection = Sections::writing;

            } else { // done writing
                // write back the answer to register file
                regfileWrite.dst = 0; // not relevant
                regfileWrite.dstData = ans;
                syscall_reg_Port->write(regfileWrite); //Perform write back

                // return to isa
                sysRES = true;
                syscall_isa_Port->write(sysRES);

                nextsection = Sections::idle;

            }
        }
        section = nextsection; // Set next section
    }
}

#endif
