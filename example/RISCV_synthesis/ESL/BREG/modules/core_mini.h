#ifndef RISCV_CORE_H_
#define RISCV_CORE_H_

#include "systemc.h"
#include "Interfaces.h"
#include "CPU_Interfaces.h"
#include "Regs.h"
#include "ISA.h"

#define REGFILE(x) RF.reg_file_##x
#define PCREG ISA_inst.pcReg

class Core : public sc_module {
public:
    // Constructor
    SC_HAS_PROCESS(Core);

    // Ports (Memory Interface)
    blocking_out<CUtoME_IF> COtoME_port;
    blocking_in<MEtoCU_IF> MEtoCO_port;

    // Components
    ISA ISA_inst;
    Regs RF;

    MasterSlave<RegfileWriteType> toRegsChannel;
    MasterSlave<RegfileType> fromRegsChannel;

    Core(sc_module_name name) :
            ISA_inst("ISA"),
            RF("RF"),
            toRegsChannel("toRegsChannel"),
            fromRegsChannel("fromRegsChannel"),
            COtoME_port("coreOutPort"),
            MEtoCO_port("coreInPort") {

        // Module port binding:
        ISA_inst.fromRegsPort(fromRegsChannel);
        RF.fromRegsPort(fromRegsChannel);
        ISA_inst.toRegsPort(toRegsChannel);
        RF.toRegsPort(toRegsChannel);

        // Memory interface forwarded to outside
        ISA_inst.toMemoryPort(COtoME_port);
        ISA_inst.fromMemoryPort(MEtoCO_port);
    }
};
#endif //RISCV_CORE_H_
