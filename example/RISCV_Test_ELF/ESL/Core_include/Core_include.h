//
// Created by PauliusMorku on 8/20/18.
//

#ifndef PROJECT_CORE_INCLUDE_H
#define PROJECT_CORE_INCLUDE_H

/// #################################
/// ADD YOUR CORE IMPLEMENTATION HERE
/// #################################


/// ############ WORKING RISCV MODELS ############

#include "../../RISCV_ISA/ESL/Core.h" // Remark: Choose memory_complicated.
//#include "../../RISCV_Pipelined/ESL/Core.h" // Remark: Choose memory_complicated.


/// ############ UNDER MAINTAINANCE ##############
//#include "../../RISCV_MS/ESL/Core.h" // Remark: Choose memory_complicated.
//#include "../../RISCV_OLD/ESL/Core.h" // Remark: Choose memory_complicated.

//#include "../../RISCV_Pipelined_3S/Blocking/ESL/Core.h"


/// #################################
/// ADD YOUR CORE COMPATIBLE MEMORY HERE
/// #################################

//#include "../ELFstyle/memory.h"
#include "../ELFstyle/memory_complicated.h"

#endif //PROJECT_CORE_INCLUDE_H
