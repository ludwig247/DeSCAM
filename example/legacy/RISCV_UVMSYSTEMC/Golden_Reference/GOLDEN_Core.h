//
// Created by paulius on 06.14.18.
//

#ifndef GOLDEN_CORE_H_
#define GOLDEN_CORE_H_


#include "systemc.h"
#include "Interfaces.h"
#include "GOLDEN_CPU_Interfaces.h"
#include "GOLDEN_ISA.h"
#include "GOLDEN_Regs.h"

class G_Core : public sc_module {
public:
    // Constructor
    SC_HAS_PROCESS(G_Core);

    // Ports (Memory Interface)
    blocking_out<CUtoME_IF> COtoME_port;
    blocking_in<MEtoCP_IF> MEtoCO_port;

    // Components
    G_ISA isa;
    G_Regs RF;

    MasterSlave<G_RegfileWriteType> toRegsChannel;
    MasterSlave<G_RegfileType> fromRegsChannel;

    G_Core(sc_module_name name) :
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

#endif //GOLDEN_CORE_H_