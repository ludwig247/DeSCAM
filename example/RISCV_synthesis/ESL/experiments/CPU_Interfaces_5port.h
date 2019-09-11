#ifndef RISCV_CPU_INTERFACES_H
#define RISCV_CPU_INTERFACES_H

#include "../../RISCV_commons/Memory_Interfaces.h"

// register file input interface
struct ISAtoRF_write_t {
    unsigned int dst;
    unsigned int dstData;
};

struct ISAtoRF_select_t {
    unsigned int src;
};

// register file output interface
struct RFtoISA_read_t {
    unsigned int data;
};

#endif // RISCV_CPU_INTERFACES_H