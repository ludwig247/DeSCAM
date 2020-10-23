//
// Created by ovsthus on 21.05.19.
//

#ifndef FULL_CSR_H
#define FULL_CSR_H


//Privilege level values

#define MachineMode 3
#define SupervisorMode 1
#define UserMode 0


//Exception code values

#define EXC_MISALIGNED_ADR_INSTR     0x00000000
#define EXC_INSTR_ACC_FAULT          0x00000001
#define EXC_ILLEGAL_INSTRUCTION      0x00000002
#define EXC_BREAKPOINT               0x00000003
#define EXC_LOAD_ADR_MISALIGNED      0x00000004
#define EXC_LOAD_ACC_FAULT           0x00000005
#define EXC_STORE_AMO_ADR_MISALIGNED 0x00000006
#define EXC_STORE_AMO_ACC_FAULT      0x00000007
#define EXC_ECALL_U_MODE             0x00000008
#define EXC_ECALL_S_MODE             0x00000009
#define EXC_ECALL_M_MODE             0x0000000B
#define EXC_INSTR_PAGE_FAULT         0x0000000C
#define EXC_LOAD_PAGE_FAULT          0x0000000D
#define EXC_STORE_AMO_PAGE_FAULT     0x0000000F
#define EXCEPTION   0x40000000 //needed to detect exception code = 0, not a real RISCV value and must be hidden outside implementation

//is shamt[5] = 1
#define SHAMT5 0x02000000


//Interrupt cause values
#define INTERRUPT static_cast<unsigned int> (0x80000000)
#define EXC_M_EXTERNAL_INTERRUPT 0x0000000B
#define EXC_M_SOFTWARE_INTERRUPT 0x00000003
#define EXC_M_TIMER_INTERRUPT 0x00000007
#define EXC_S_EXTERNAL_INTERRUPT 0x00000009
#define EXC_S_SOFTWARE_INTERRUPT 0x00000001
#define EXC_S_TIMER_INTERRUPT 0x00000005
#define EXC_U_EXTERNAL_INTERRUPT 0x00000008
#define EXC_U_SOFTWARE_INTERRUPT 0x00000000
#define EXC_U_TIMER_INTERRUPT 0x00000004



#define MTRAP_ML12I(x)  ((x) & 0x00001000)
#define MSTATUS_MIE(x)  ((x) & 0x00000008)
#define MTRAP_MEI(x)    ((x) & 0x00000800)
#define MTRAP_MSI(x)    ((x) & 0x00000008)
#define MTRAP_MTI(x)    ((x) & 0x00000080)
#define MSTATUS_SIE(x)  ((x) & 0x00000002)
#define MTRAP_SEI(x)    ((x) & 0x00000200)
#define MTRAP_SSI(x)    ((x) & 0x00000002)
#define MTRAP_STI(x)    ((x) & 0x00000020)
#define MSTATUS_UIE(x)  ((x) & 0x00000001)
#define MTRAP_UEI(x)    ((x) & 0x00000100)
#define MTRAP_USI(x)    ((x) & 0x00000001)
#define MTRAP_UTI(x)    ((x) & 0x00000010)


//obtain CSR R/W and privilege fields
#define getCSRprivlvl(x) (((x) >> 8) & 3)
#define getCSRrwtype(x) (((x) >> 10) & 3)

//SHADOWS FOR TIMERS
#define UCSR_CYCLE      0xC00
#define UCSR_CYCLE_H    0xC80
#define UCSR_TIME       0xC01
#define UCSR_TIME_H     0xC81
#define UCSR_INSTRET    0xC02
#define UCSR_INSTRET_H  0xC82

//64 BIT TIMER CSR's
#define MCSR_MCYCLE     0xB00
#define MCSR_MCYCLE_H   0xB80
#define MCSR_MTIME      0xB01 //shadow of memory mapped mtime
#define MCSR_MTIME_H    0xB81
#define MCSR_MINSTRET   0xB02
#define MCSR_MINSTRET_H 0xB82

//MACHINE CSR's
#define MCSR_MSTATUS    0x300
#define MCSR_MISA       0x301
#define MCSR_MEDELEG    0x302
#define MCSR_MIDELEG    0x303
#define MCSR_MIE        0x304
#define MCSR_MTVEC      0x305
#define MCSR_MCOUNTEREN 0x306
#define MCSR_MSCRATCH   0x340
#define MCSR_MEPC       0x341
#define MCSR_MCAUSE     0x342
#define MCSR_MTVAL      0x343
#define MCSR_MIP        0x344
#define MCSR_MVENDORID  0xF11
#define MCSR_MARCHID    0xF12
#define MCSR_MIMPID     0xF13
#define MCSR_MHARTID    0xF14


//PHYSICAL MEMORY PROTECTION CSR's (not in use)
#define MCSR_PMPCFG0    0x3A0
#define MCSR_PMPCFG1    0x3A1
#define MCSR_PMPCFG2    0x3A2
#define MCSR_PMPCFG3    0x3A3

#define MCSR_PMPADDR0   0x3B0
#define MCSR_PMPADDR1   0x3B1
#define MCSR_PMPADDR2   0x3B2
#define MCSR_PMPADDR3   0x3B3
#define MCSR_PMPADDR4   0x3B4
#define MCSR_PMPADDR5   0x3B5
#define MCSR_PMPADDR6   0x3B6
#define MCSR_PMPADDR7   0x3B7
#define MCSR_PMPADDR8   0x3B8
#define MCSR_PMPADDR9   0x3B9
#define MCSR_PMPADDR10  0x3BA
#define MCSR_PMPADDR11  0x3BB
#define MCSR_PMPADDR12  0x3BC
#define MCSR_PMPADDR13  0x3BD
#define MCSR_PMPADDR14  0x3BE
#define MCSR_PMPADDR15  0x3BF


//SUPERVISOR CSR's
#define SCSR_SSTATUS    0x100
#define SCSR_SEDELEG    0x102
#define SCSR_SIDELEG    0x103
#define SCSR_SIE        0x104
#define SCSR_STVEC      0x105
#define SCSR_SCOUNTEREN 0x106
#define SCSR_SSCRATCH   0x140
#define SCSR_SEPC       0x141
#define SCSR_SCAUSE     0x142
#define SCSR_STVAL      0x143
#define SCSR_SIP        0x144
#define SCSR_SATP       0x180

//USER CSR's
#define UCSR_USTATUS    0x000
#define UCSR_UIE        0x004
#define UCSR_UTVEC      0x005
#define UCSR_USCRATCH   0x040
#define UCSR_UEPC       0x041
#define UCSR_UCAUSE     0x042
#define UCSR_UTVAL      0x043
#define UCSR_UIP        0x044

//Perfomance counter address ranges (for valid address detection)

#define HPMCOUNTER_L_3  0xC03
#define HPMCOUNTER_L_31 0xC1F

#define HPMCOUNTER_H_3  0xC83
#define HPMCOUNTER_H_31 0xC9F

#define MHPMCOUNTER_L_3  0xB03
#define MHPMCOUNTER_L_31 0xB1F

#define MHPMCOUNTER_H_3  0xB83
#define MHPMCOUNTER_H_31 0xB9F

#define MHPMEVENT_3      0x323
#define MHPMEVENT_31     0x33F

//MASKS

#define MIE_MASK 0x00000BBB   // 0b101110111011;
#define SIE_MASK 0x00000333   // 0b001100110011;
#define UIE_MASK 0x00000111   // 0b000100010001;

#define MIP_WRITE_MASK 0x00000333 // 0b001100110011;
#define MIP_READ_MASK  MIE_MASK
#define SIP_WRITE_MASK 0x00000103   //
#define SIP_READ_MASK 0x00000333
#define UIP_WRITE_MASK 0x00000001    // 0b1;
#define UIP_READ_MASK 0x00000111

#define MEDELEG_MASK 0x0000B3FF // 0b1011001111111111;
#define MIDELEG_MASK  MIE_MASK

#define MTVEC_MASK -3 //~2 //bit 1 reserved
#define XTVEC_VECTORED 0x00000001
#define XTVEC_BASE_MASK  -4  //0xFFFFFFFC
#define MEPC_MASK -4 //~3 lower two bits always 0

#define MCOUNTEREN_MASK 0x00000007  // 0b111;


#define SEDELEG_MASK 0x0000B1FF  // 0b1011000111111111;
#define SIDELEG_MASK  MIDELEG_MASK

#define MSTATUS_MASK  static_cast<unsigned int>(0x807FF9BB)  // 0b10000000011111111111100110111011;
#define SSTATUS_MASK  static_cast<unsigned int>(0x800DE133)  // 0b10000000000011011110000100110011;
#define USTATUS_MASK  0x00000011  //  0b00000000000000000000000000010001;

//MSTATUS bitmasks

#define MSTATUS_MPRV 0x00020000
#define MSTATUS_SUM  0x00040000
#define MSTATUS_MXR  0x00080000
#define MSTATUS_TVM  0x00100000
#define MSTATUS_TSR  0x00400000
#define MSTATUS_TW   0x00200000
#define MSTATUS_MPP  0x00001800
#define MSTATUS_SPP  0x00000100
#define MSTATUS_MPIE 0x00000080
#define MSTATUS_SPIE 0x00000020
#define MSTATUS_UPIE 0x00000010
#define MSTATUS_MIE_ 0x00000008
#define MSTATUS_SIE_ 0x00000002
#define MSTATUS_UIE_ 0x00000001

#define MPP_ALIGN(x) (((x) & MSTATUS_MPP) >> 11)
#define SPP_ALIGN(x) (((x) & MSTATUS_SPP) >> 8)
#define MPIE_ALIGN(x) (((x) & MSTATUS_MPIE) >> 4) //NOTE: aligns MPIE to MIE not 0
#define SPIE_ALIGN(x) (((x) & MSTATUS_SPIE) >> 4)
#define UPIE_ALIGN(x) (((x) & MSTATUS_UPIE) >> 4)

#define CLEAR_MSTATUS_TRAP (MSTATUS_MPP | MSTATUS_MPIE | MSTATUS_MIE_ | MSTATUS_SIE_ | MSTATUS_UIE_)
#define CLEAR_SSTATUS_TRAP (MSTATUS_SPP | MSTATUS_SPIE | MSTATUS_SIE_ | MSTATUS_UIE_)
#define CLEAR_USTATUS_TRAP (MSTATUS_UPIE | MSTATUS_UIE_)



#endif //FULL_CSR_H
