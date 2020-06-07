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
        SC_THREAD(run_2);
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
    CUtoME_IF memoryAccess;
    MEtoCU_IF fromMemoryData;

    //data for communication with CPU
    unsigned int addr;
    unsigned int data;

    void run();
    void run_2();
};

void IMEM_ctrl::run() {
    while (true){
        wait(WAIT_TIME, SC_PS);
        fromCPUPort->slave_read(addr);


        // Set up memory access
        memoryAccess.req = ME_RD;
        memoryAccess.mask = MT_W; // always for instructions
        memoryAccess.addrIn = addr;
        memoryAccess.dataIn = 0;    // not relevant

        toMemoryPort->write(memoryAccess); //Send request to memory
        fromMemoryPort->read(fromMemoryData); //Read encoded instruction from memory

        data = fromMemoryData.loadedData;

        toCPUPort->slave_write(data);
        wait(WAIT_TIME, SC_PS);
    }
}

void IMEM_ctrl::run_2() {
    while (true){
        dataFromCPUPort->read(memoryAccess);
        //wait(WAIT_TIME, SC_PS);
        toMemoryPort->write(memoryAccess); //Send request to memory

        fromMemoryPort->read(fromMemoryData); //Read encoded instruction from memory

        data = fromMemoryData.loadedData;
        dataToCPUPort->slave_write(data);
        //wait(WAIT_TIME, SC_PS);
    }
}

#endif //DESCAM_IMEM_CTRL_H
