//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 13.10.18.
//

#ifndef RISCV_CORE_H
#define RISCV_CORE_H

// Adjusts code to be appropriate for the SCAM tool
// Working ESL-Description -> #define NOSCAM
// Properties can be generated -> //#define NOSCAM
//#define NOSCAM

#include "systemc.h"
#include "Interfaces.h"
#include "CPU_Interfaces.h"
#include "ISA.h"
#include "regs.h"
#include "mip.h"

#include "Bus.h"
#include "CLINT/CLINT.h"

#define REGFILE(x) RF.reg_file_##x
#define PCREG ISA_inst.pcReg

class Core : public sc_module {
public:

    //Constructor
    SC_HAS_PROCESS(Core);

    // Outside connections
    // Ports (Memory Interface)
    blocking_out<CUtoME_IF> COtoME_port;
    blocking_in<MEtoCU_IF> MEtoCO_port;

    // interrupts connections
    MasterSlave<bool> MSIP_to_mip;
    MasterSlave<bool> MTIP_to_mip;
    // Components
    ISA ISA_inst;
    Regs RF;
    Mip mip;
    Bus bus;
    CLINT clint;

    // Channels
    // Inside Channels (ISA_REG)
    MasterSlave<RegfileWriteType> toRegsChannel;
    MasterSlave<RegfileType> fromRegsChannel;

    // Inside Channels (ISA_BUS)
    Blocking<CUtoME_IF> isa_bus_Channel;
    Blocking<MEtoCU_IF> bus_isa_Channel;

    // Inside Channels (ISA_MIP)
    MasterSlave<unsigned int> mip_isa_Channel;

    //(connecting bus to clint memory)
    Blocking<CUtoME_IF> bus_to_clint_memory;
    Blocking<MEtoCU_IF> clint_memory_to_bus;

    Core(sc_module_name name) :
            ISA_inst("isa"),
            RF("RF"),
            mip("mip"),
            bus("bus"),
            clint("clint"),
            COtoME_port("core_out"),
            MEtoCO_port("core_in"),
            toRegsChannel("toRegsChannel"),
            fromRegsChannel("fromRegsChannel"),
            isa_bus_Channel("isa_bus_Channel"),
            bus_isa_Channel("bus_isa_Channel"),
            mip_isa_Channel("mip_isa_Channel"),
            bus_to_clint_memory("bus_to_clint_memory"),
            clint_memory_to_bus("clint_memory_to_bus"),
            MSIP_to_mip("MSIP_to_mip"),
            MTIP_to_mip("MTIP_to_mip") {
        ////////////// Channel instantiation
        //(connecting inner core to bus)
        // Module port binding: (ISA_REG)
        ISA_inst.fromRegsPort(fromRegsChannel);
        RF.fromRegsPort(fromRegsChannel);
        ISA_inst.toRegsPort(toRegsChannel);
        RF.toRegsPort(toRegsChannel);

        // Module port binding: (ISA_BUS)
        ISA_inst.toMemoryPort(isa_bus_Channel);
        bus.isa_bus_Port(isa_bus_Channel);
        ISA_inst.fromMemoryPort(bus_isa_Channel);
        bus.bus_isa_Port(bus_isa_Channel);

        // Module port binding: (ISA_MIP)
        ISA_inst.mip_isa_Port(mip_isa_Channel);
        mip.mip_isa_Port(mip_isa_Channel);

        //(connecting bus to outside boundary (memory))
        bus.BUStoMEM_port(COtoME_port);
        bus.MEMtoBUS_port(MEtoCO_port);

        //(connecting bus to clint memory)
        clint.COtoME_port(bus_to_clint_memory);
        clint.MEtoCO_port(clint_memory_to_bus);
        bus.BUStoCLINT_port(bus_to_clint_memory);
        bus.CLINTtoBUS_port(clint_memory_to_bus);

        //(connecting interrupts to the core)
        mip.MSIP_port(MSIP_to_mip);
        clint.MSIP_port(MSIP_to_mip);
        mip.MTIP_port(MTIP_to_mip);
        clint.MTIP_port(MTIP_to_mip);
    }

};

#endif //RISCV_CORE_H