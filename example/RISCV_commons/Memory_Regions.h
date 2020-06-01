#ifndef MEMORY_REGIONS_H
#define MEMORY_REGIONS_H

/// Addressing
#define MEM_DEPTH                       0x40000 // 1024*1024*32 // 32 MB ram
#define MEM_START_ADDR                  0x00000000
#define MEM_END_ADDR                    MEM_START_ADDR + MEM_DEPTH

#define CLINT_START_ADDR                0x02000000
#define CLINT_END_ADDR                  0x0200ffff
#define CLINT_msip_ADDR                 0x02000000
#define CLINT_mtimecmp_ADDR             0x02004000
#define CLINT_mtime_ADDR                0x0200BFF8

#define PLIC_START_ADDR                 0x0C000000
#define PLIC_END_ADDR                   0x0C200008
#define PLIC_Priority_ADDR              0x0C000000
#define PLIC_Pending_ADDR               0x0C001000
#define PLIC_Interrupt_Enables_ADDR     0x0C002000
#define PLIC_Threshold_ADDR             0x0C200000
#define PLIC_Claim_Complete_ADDR        0x0C200004

#define CORETEMPSENSOR_START_ADDR       0x40000000
#define CORETEMPSENSOR_END_ADDR         0x40000008
#define CORETEMPSENSOR_Tthreshold_ADDR  0x40000000
#define CORETEMPSENSOR_Tcur_ADDR        0x40000004

#endif // MEMORY_REGIONS_H