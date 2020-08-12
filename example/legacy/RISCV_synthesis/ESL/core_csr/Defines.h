//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 13.10.18.
//

#ifndef PROJECT_DEFINES_H
#define PROJECT_DEFINES_H

#define CLINT_START_ADDR    0x02000000
#define CLINT_END_ADDR      0x0200ffff
#define CLINT_msip_ADDR     0x02000000
#define CLINT_mtimecmp_ADDR 0x02004000
#define CLINT_mtime_ADDR    0x0200BFF8

#define PLIC_START_ADDR     0x40000000
#define PLIC_END_ADDR       0x40001000
#define PLIC_Priority_ADDR          0x40000000
#define PLIC_Pending_ADDR           0x40000100
#define PLIC_Interrupt_Enables_ADDR 0x40000200
#define PLIC_Threshold_ADDR         0x40000000
#define PLIC_Claim_Complete_ADDR    0x40000004

#define CORETEMPSENSOR_START_ADDR     0x0C200010
#define CORETEMPSENSOR_END_ADDR       0x0C200018
#define CORETEMPSENSOR_Tthreshold_ADDR  0x0C200010
#define CORETEMPSENSOR_Tcur_ADDR        0x0C200014

#define Fill(amt) ((1 << amt) - 1)


//#define SYS_write 64 // 0x00000040 // 64
//#define SYS_exit 93 // 0x0000005D // 93


#endif // PROJECT_DEFINES_H