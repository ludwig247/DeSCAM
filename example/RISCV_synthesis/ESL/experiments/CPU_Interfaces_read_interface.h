#ifndef RISCV_CPU_INTERFACES_H
#define RISCV_CPU_INTERFACES_H

#include "../../RISCV_commons/Memory_Interfaces.h"

enum RF_AccessType {
    RF_X, RF_RD, RF_WR
};

// register file input interface
struct ISAtoRF_IF {
    unsigned int dst;
    unsigned int dstData;
    RF_AccessType rwReq;
};

// register file output interface
struct RFtoISA_IF {
    unsigned int data;
};

#endif // RISCV_CPU_INTERFACES_H