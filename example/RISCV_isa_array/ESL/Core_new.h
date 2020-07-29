//
// Created by paulius on 06.14.18.
//

#ifndef RISCV_CORE_H_
#define RISCV_CORE_H_


#include "systemc.h"
#include "../../Interfaces/Interfaces.h"
#include "CPU_Interfaces.h"
#include "ISA_array.h"
#include "regs_array.h"
//#include "ISA_array_sim.h"
//#include "ISA_struct.h"
//#include "regs_struct.h"
//#include "ISA.h"
//#include "regs.h"


#define REGFILE(x) RF.reg_file_##x
#define PCREG isa.pcReg

class Core : public sc_module {
public:
    // Constructor
    SC_HAS_PROCESS(Core);

    // Ports (Memory Interface)
    blocking_out<CUtoME_IF> COtoME_port;
    blocking_in<MEtoCU_IF> MEtoCO_port;

    // Components
    ISA_new isa;
    Regs_new RF;

    MasterSlave<RegfileWriteType> toRegsChannel;
    MasterSlave<unsigned int[32]> fromRegsChannel;
    //MasterSlave<RegfileType> fromRegsChannel;

    Core(sc_module_name name) :
            isa("isa"),
            RF("RF"),
            toRegsChannel("toRegsChannel"),
            fromRegsChannel("fromRegsChannel"),
            COtoME_port("coreOutPort"),
            MEtoCO_port("coreInPort")
    {

        // Module port binding:
        isa.fromRegsPort(fromRegsChannel);
        RF.fromRegsPort(fromRegsChannel);
        isa.toRegsPort(toRegsChannel);
        RF.toRegsPort(toRegsChannel);

        // Memory interface forwarded to outside
        isa.toMemoryPort(COtoME_port);
        isa.fromMemoryPort(MEtoCO_port);
    }
};

#endif //RISCV_CORE_H_