//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 13.10.18.
//

#ifndef RISCV_ISA_MEMORY_H
#define RISCV_ISA_MEMORY_H

#include <stdint.h>
#include <iostream>
#include "systemc"
#include "Interfaces.h"
#include "Memory_Interfaces.h"
#include "Defines.h"

class Memory : public sc_module {
public:
    SC_HAS_PROCESS(Memory);
    uint8_t *mem;
    uint32_t size;

    //Ports
    blocking_in<CUtoME_IF> COtoME_port; // read_instruction/load/store
    blocking_out<MEtoCU_IF> MEtoCO_port; // store/load done

    CUtoME_IF CPtoME_data;
    MEtoCU_IF MEtoCP_data;

    Memory(sc_core::sc_module_name, uint32_t size) :
            COtoME_port("COtoME_port"),
            MEtoCO_port("MEtoCO_port"),
    mem(new uint8_t[size]()),
    size(size) {
        SC_THREAD(run); // register thread with kernel
    }

    void run(); // thread
};

void Memory::run() {
    while (true) {
        MEtoCP_data.loadedData = 0;

        COtoME_port->read(CPtoME_data); //Wait for next request
        if (CPtoME_data.addrIn < MEM_START_ADDR || CPtoME_data.addrIn >= MEM_END_ADDR) {
            cout << "@ME: Accessing out of bound. Terminating! " << hex << CPtoME_data.addrIn<< endl;
            sc_stop();
            wait(SC_ZERO_TIME);
        }

        unsigned int targeted_addr = CPtoME_data.addrIn - MEM_START_ADDR;
        if (CPtoME_data.req != ME_X) {

            if (CPtoME_data.req == ME_RD) { // LOAD
                // Little endian: Least significant byte in the smallest address...
                if (CPtoME_data.mask != MT_X) {
                    if (CPtoME_data.mask == MT_W) {
                        MEtoCP_data.loadedData = *(mem + targeted_addr)
                                                 + ((*(mem + targeted_addr + 1)) << 8)
                                                 + (*(mem + targeted_addr + 2) << 16)
                                                 + (*(mem + targeted_addr + 3) << 24);
                    } else if (CPtoME_data.mask == MT_H) {
                        MEtoCP_data.loadedData = *(mem + targeted_addr)
                                                 + (*(mem + targeted_addr + 1) << 8);
                        // sign extend
                        if ((MEtoCP_data.loadedData & 0x00008000)) {
                            MEtoCP_data.loadedData = 0xFFFF0000 | (MEtoCP_data.loadedData & 0x0000FFFF);
                        }
                    } else if (CPtoME_data.mask == MT_B) {
                        MEtoCP_data.loadedData = *(mem + targeted_addr);
                        // sign extend
                        if ((MEtoCP_data.loadedData & 0x00000080)) {
                            MEtoCP_data.loadedData = 0xFFFFFF00 | (MEtoCP_data.loadedData & 0x000000FF);
                        }
                    } else if (CPtoME_data.mask == MT_HU) {
                        MEtoCP_data.loadedData = *(mem + targeted_addr)
                                                 + (*(mem + targeted_addr + 1) << 8);
                    } else if (CPtoME_data.mask == MT_BU) {
                        MEtoCP_data.loadedData = *(mem + targeted_addr);
                    } else {
                        throw std::logic_error(std::string("@ME: Unauthorized read. Terminating!"));
                    }
                }
                MEtoCO_port->write(MEtoCP_data);
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
            } else if (CPtoME_data.req == ME_WR) {
                if (CPtoME_data.mask != MT_X) {
                    // Little endian: Least significant byte in the smallest address...
                    if (CPtoME_data.mask == MT_W) {
                        *(mem + targeted_addr) = CPtoME_data.dataIn & 0xFF;
                        *(mem + targeted_addr + 1) = (CPtoME_data.dataIn >> 8) & 0xFF;
                        *(mem + targeted_addr + 2) = (CPtoME_data.dataIn >> 16) & 0xFF;
                        *(mem + targeted_addr + 3) = (CPtoME_data.dataIn >> 24) & 0xFF;
                    } else if (CPtoME_data.mask == MT_H) {
                        *(mem + targeted_addr) = CPtoME_data.dataIn & 0xFF;
                        *(mem + targeted_addr + 1) = (CPtoME_data.dataIn >> 8) & 0xFF;
                    } else if (CPtoME_data.mask == MT_B) {
                        *(mem + targeted_addr) = CPtoME_data.dataIn & 0xFF;
                    } else if (CPtoME_data.mask == MT_BU || CPtoME_data.mask == MT_HU) {
                        throw std::logic_error(std::string("@ME: Unauthorized write, illegal mask. Terminating!"));
                    } else {
                        throw std::logic_error(std::string("@ME: Unauthorized write. Terminating!"));
                    }
                }
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
            } else {
                throw std::logic_error(std::string("@ME: Undefined memory req"));
            }
        }
    }
}

#endif //RISCV_ISA_MEMORY_H
