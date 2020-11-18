//
// Created by PauliusMorku on 8/20/18.
//

#ifndef PROJECT_CORE_INCLUDE_H
#define PROJECT_CORE_INCLUDE_H

/// #################################
/// ADD YOUR CORE IMPLEMENTATION HERE
/// #################################

//#include "../../../RISCV_interrupts/ESL/NoPLIC_new/Core.h"
//#include "../../../RISCV_interrupts/ESL/Full_new/Core.h"

//#include "../../../RISCV_UVMSYSTEMC/Golden_Reference/GoldenCore.h"
//#include "../../../RISCV_UVMSYSTEMC_INT/Golden_Reference/GOLDEN_Core.h"
//#include "../../../RISCV_UVMSYSTEMC_INT/DUT_INT/Original/Core.h"
//#include "../../../RISCV_interrupts/ESL/Full/Core.h"
//#include "../../../RISCV_interrupts/ESL/NoPLIC/Core.h"
//#include "../../../RISCV_interrupts/ESL/NoPLIC_NOsysCall/Core.h"

#include "../../../RISCV_ISA/ESL/env/Core_i.h" // Remark: Choose memory_complicated.
//#include "../../RISCV_RI5CY/ESL/Core_new.h" // Remark: Choose memory_complicated.
//#include "../../RISCV_ISA/ESL/Core.h" // Remark: Choose memory_complicated.
                                        // FIXME: one test failed (BubbleSort)

//#include "../../RISCV_Pipelined/ESL/Core_new.h" // Remark: Choose memory_complicated.
//#include "../../RISCV_Pipelined/ESL/Core.h" // Remark: Choose memory_complicated.
                                              // FIXME: c_code tests failed


//#include "../../RISCV_synthesis/ESL/core_simple/Core.h"
//#include "../../RISCV_synthesis/ESL/core_csr/Core.h"
//#include "../../RISCV_synthesis/ESL/core_ecall/Core.h"

//#include "../../RISCV_MS/ESL/Core.h" // Remark: Choose memory_complicated.
                                       // FIXME: test failed (BubbleSort) and test stuck (Fibonacci)


//#include "../../RISCV_OLD/ESL/Core.h" // Remark: Choose memory_complicated.

//#include "../../RISCV_synthesis/ESL/BREG/build/generated/Core.h"


/// #################################
/// ADD YOUR CORE COMPATIBLE MEMORY HERE
/// #################################

//#include "../ELFstyle/memory.h"
#include "../ELFstyle/memory_complicated.h"

#endif //PROJECT_CORE_INCLUDE_H
