//
// Created by SIDNEY on 29/05/2020.
//

#ifndef DESCAM_IMEM_CTRL_H
#define DESCAM_IMEM_CTRL_H

#include "systemc.h"
#include "../../Interfaces/Interfaces.h"
#include "../../RISCV_commons/Memory_Interfaces.h"

class IMEM_ctrl : public sc_module {
public:
    SC_HAS_PROCESS(IMEM_ctrl);
    IMEM_ctrl(sc_module_name) :
        toMemoryPort("toMemoryPort"),
        fromMemoryPort("fromMemoryPort"),
        toCPUPort("toCPUPort"),
        fromCPUPort("fromCPUPort"),
        addr(0),
        data(0)
    {
        SC_THREAD(run);
    }

    // ports for communication with memory
    blocking_out<CUtoME_IF> toMemoryPort;
    blocking_in<MEtoCU_IF> fromMemoryPort;

    //ports for communication with CPU for instruction
    slave_in<unsigned int > fromCPUPort;
    slave_out<unsigned int> toCPUPort;

    //ports for communication with CPU for data
    blocking_in<CUtoME_IF> dataFromCPUPort;
    slave_out<unsigned int > dataToCPUPort;

    // data for communication with memory
    CUtoME_IF imemMemoryAccess;
    MEtoCU_IF imemFromMemoryData;

    CUtoME_IF dmemMemoryAccess;
    MEtoCU_IF dmemFromMemoryData;

    //data for communication with CPU
    unsigned int addr;
    unsigned int instr;
    unsigned int data;

    //flags
    bool flagFromCPUPort;
    bool flagDmemMemoryAccess;

    void run();
};

void IMEM_ctrl::run(){
    while (true){
        fromCPUPort->slave_read(addr, flagFromCPUPort);
        if(flagFromCPUPort){
            // Set up memory access
            imemMemoryAccess.req = ME_RD;
            imemMemoryAccess.mask = MT_W; // always for instructions
            imemMemoryAccess.addrIn = addr;
            imemMemoryAccess.dataIn = 0;    // not relevant

            toMemoryPort->write(imemMemoryAccess); //Send request to memory
            fromMemoryPort->read(imemFromMemoryData); //Read encoded instruction from memory
            instr = imemFromMemoryData.loadedData;

            dataFromCPUPort->try_read(dmemMemoryAccess, flagDmemMemoryAccess);
            if(flagDmemMemoryAccess){
                toMemoryPort->write(dmemMemoryAccess); //Send request to memory
                fromMemoryPort->read(dmemFromMemoryData); //Read encoded instruction from memory

                data = dmemFromMemoryData.loadedData;

                dataToCPUPort->slave_write(data);
            }
            toCPUPort->slave_write(instr);
        }else{
            //toCPUPort->slave_write(instr);
            wait(WAIT_TIME, SC_PS);
        }
    }
}

#endif //DESCAM_IMEM_CTRL_H

