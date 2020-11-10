#ifndef BUS_H
#define BUS_H

#include "systemc"
#include "Interfaces.h"
#include "Memory_Interfaces.h"
#include "CPU_Interfaces.h"
#include "CLINT.h"
#include "PLIC.h"

struct Bus: sc_module {
    blocking_in<CUtoME_IF> isa_bus_Port;
    blocking_out<MEtoCU_IF> bus_isa_Port;

    blocking_out<CUtoME_IF> BUStoMEM_port;
    blocking_in<MEtoCU_IF> MEMtoBUS_port;

    blocking_out<CUtoME_IF> BUStoCLINT_port;
    blocking_in<MEtoCU_IF> CLINTtoBUS_port;

    blocking_out<CUtoME_IF> BUStoPLIC_port;
    blocking_in<MEtoCU_IF> PLICtoBUS_port;

    CUtoME_IF CPtoME_data;
    MEtoCU_IF MEtoCP_data;
    bool rec;

    SC_CTOR(Bus) :
            BUStoMEM_port("BUStoMEM_port"),
            MEMtoBUS_port("MEMtoBUS_port"),
            BUStoCLINT_port("BUStoCLINT_port"),
            CLINTtoBUS_port("CLINTtoBUS_port"),
            BUStoPLIC_port("BUStoPLIC_port"),
            PLICtoBUS_port("PLICtoBUS_port"),
            isa_bus_Port("isa_bus_Port"),
            bus_isa_Port("bus_isa_Port"),
            rec(false) {
        SC_THREAD(run);
    }

    void run() {
        while (true) {
            isa_bus_Port->read(CPtoME_data);
            if (CPtoME_data.addrIn >= MEM_START_ADDR && CPtoME_data.addrIn < MEM_END_ADDR) {
                BUStoMEM_port->write(CPtoME_data);
                if (CPtoME_data.req == ME_RD) {
                    MEMtoBUS_port->read(MEtoCP_data);
                    bus_isa_Port->write(MEtoCP_data);
                }
            } else if (CPtoME_data.addrIn >= CLINT_START_ADDR && CPtoME_data.addrIn < CLINT_END_ADDR) {
                BUStoCLINT_port->write(CPtoME_data);
                if (CPtoME_data.req == ME_RD) {
                    CLINTtoBUS_port->read(MEtoCP_data);
                    bus_isa_Port->write(MEtoCP_data);
                }
            } else if (CPtoME_data.addrIn >= PLIC_START_ADDR && CPtoME_data.addrIn < PLIC_END_ADDR) {
                BUStoPLIC_port->write(CPtoME_data);
                if (CPtoME_data.req == ME_RD) {
                    PLICtoBUS_port->read(MEtoCP_data);
                    bus_isa_Port->write(MEtoCP_data);
                }
            } else {
#ifdef SC_SIMULATE
                cout << "@BUS: Accessing out of bound. 0x" << std::hex << CPtoME_data.addrIn << ")" << endl;
                sc_stop();
                wait(SC_ZERO_TIME);
#endif
            }
        }
    }
};

#endif
