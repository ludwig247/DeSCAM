//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 13.10.18.
//

#ifndef INNERBUS_H
#define INNERBUS_H

#include "systemc"
#include "Interfaces.h"
#include "../Memory_Interfaces.h"

struct InnerBus: sc_module {
    blocking_in<CUtoME_IF> syscall_bus_Port;
    blocking_out<MEtoCU_IF> bus_syscall_Port;

    blocking_in<CUtoME_IF> isa_bus_Port;
    blocking_out<MEtoCU_IF> bus_isa_Port;

    // ports for communication with memory/decoder
    blocking_out<CUtoME_IF> COtoME_port;
    blocking_in<MEtoCU_IF> MEtoCO_port;

    // data for communication with memory
    CUtoME_IF memoryAccess;
    MEtoCU_IF fromMemoryData;

    bool rec;

    SC_CTOR(InnerBus) :
            syscall_bus_Port("syscall_bus_Port"),
            bus_syscall_Port("bus_syscall_Port"),
            isa_bus_Port("isa_bus_Port"),
            bus_isa_Port("bus_isa_Port"),
            COtoME_port("COtoME_port"),
            MEtoCO_port("MEtoCO_port"),
            rec(false) {
        SC_THREAD(run);
    }

    void run() {
        while (true) {
            rec = isa_bus_Port->nb_read(memoryAccess);
            if (rec) {
                COtoME_port->write(memoryAccess);
                if(memoryAccess.req == ME_RD) {
                    //wait for response from memory
                    MEtoCO_port->read(fromMemoryData);
                    //write back memory response to isa
                    bus_isa_Port->write(fromMemoryData);
                }
            }
            rec = syscall_bus_Port->nb_read(memoryAccess);
            if (rec) {
                COtoME_port->write(memoryAccess);
                if(memoryAccess.req == ME_RD) {
                    //wait for response from memory
                    MEtoCO_port->read(fromMemoryData);
                    //write back memory response to syscallHandler
                    bus_syscall_Port->write(fromMemoryData);
                }
            }
        }
    }
};

#endif
