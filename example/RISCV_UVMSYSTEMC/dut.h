//
// Created by nawras on 03.08.18.
//

#ifndef UVMSYSTEMC_DUT_H
#define UVMSYSTEMC_DUT_H

#include <systemc>
#include "Interfaces.h"
#include "Memory_Interfaces.h"

class CPU_dut : public sc_core::sc_module {
public:
    blocking_out<CUtoME_IF> COtoME_port;
    blocking_in<MEtoCP_IF> MEtoCO_port;
// data for communication with memory
    CUtoME_IF memoryAccess;
    MEtoCP_IF fromMemory;
    unsigned int fromMemoryData;
    unsigned int pc_reg;

    void run() {
        while (true) {
            // Set up memory access
            memoryAccess.addrIn = pc_reg;
            memoryAccess.dataIn = 0;    // not relevant
            memoryAccess.mask = ME_MaskType::MT_W; // always for instructions
            memoryAccess.req = ME_AccessType::ME_RD;

            //Send request to memory
            std::cout << "DUT: " << " requesting instr at " << pc_reg << std::endl;
            COtoME_port->write(memoryAccess);

            //Read decoded instruction from decoder
            MEtoCO_port->read(fromMemory);
            fromMemoryData = fromMemory.loadedData;
            std::cout << "\t\t\t\t\t\t\t\t\t\tDUT: " << " received instr " << fromMemoryData << std::endl;

            if (fromMemoryData == 0x0 || fromMemoryData == 0x13) {
                break;
            }
            pc_reg = pc_reg + 4;
        }
        std::cout << sc_core::sc_time_stamp() << ": " << name() << " dut leaving " << std::endl;
    }

    SC_CTOR(CPU_dut) :
            COtoME_port("core_out"),
            MEtoCO_port("core_in"),
            fromMemoryData(0),
            pc_reg(0)
    {
        SC_THREAD(run);
    }

};
#endif //UVMSYSTEMC_DUT_H
