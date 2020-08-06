//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 13.10.18.
//

#ifndef RISCV_CORE_H
#define RISCV_CORE_H

#include "Memory_Interfaces.h"
#include "systemc.h"
#include "Interfaces.h"
#include "Defines.h"
#include "InnerCore/InnerCore.h"
#include "Peripherals/CLINT.h"
#include "Peripherals/PLIC.h"
#include "Peripherals/Bus.h"


#define REGFILE(x) innerCore.RF.reg_file_##x
#define PCREG innerCore.ISA_inst.pcReg

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
    MasterSlave<bool> MEIP_to_mip;
    // Inner components and connections
    // Components
    InnerCore innerCore;
    Bus bus;
    CLINT clint;
    PLIC plic;
    // Channels
    //(connecting core to bus)
    Blocking<CUtoME_IF> core_to_bus;
    Blocking<MEtoCU_IF> bus_to_core;
    //(connecting bus to clint memory)
    Blocking<CUtoME_IF> bus_to_clint_memory;
    Blocking<MEtoCU_IF> clint_memory_to_bus;
    //(connecting bus to plic memory)
    Blocking<CUtoME_IF> bus_to_plic_memory;
    Blocking<MEtoCU_IF> plic_memory_to_bus;

    Core(sc_module_name name) :
            innerCore("innerCore"),
            bus("bus"),
            clint("clint"),
            plic("plic"),
            COtoME_port("core_out"),
            MEtoCO_port("core_in"),
            core_to_bus("core_to_bus"),
            bus_to_core("bus_to_core"),
            bus_to_clint_memory("bus_to_clint_memory"),
            clint_memory_to_bus("clint_memory_to_bus"),
            bus_to_plic_memory("bus_to_plic_memory"),
            plic_memory_to_bus("plic_memory_to_bus"),
            MSIP_to_mip("MSIP_to_mip"),
            MTIP_to_mip("MTIP_to_mip"),
            MEIP_to_mip("MEIP_to_mip") {

        ////////////// Channel instantiation
        //(connecting inner core to bus)
        innerCore.COtoME_port(core_to_bus);
        bus.COtoBUS_port(core_to_bus);
        bus.BUStoCO_port(bus_to_core);
        innerCore.MEtoCO_port(bus_to_core);

        //(connecting bus to outside boundary (memory))
        bus.BUStoMEM_port(COtoME_port);
        bus.MEMtoBUS_port(MEtoCO_port);

        //(connecting bus to clint memory)
        clint.COtoME_port(bus_to_clint_memory);
        clint.MEtoCO_port(clint_memory_to_bus);
        bus.BUStoCLINT_port(bus_to_clint_memory);
        bus.CLINTtoBUS_port(clint_memory_to_bus);

        //(connecting bus to plic memory)
        plic.COtoME_port(bus_to_plic_memory);
        plic.MEtoCO_port(plic_memory_to_bus);
        bus.BUStoPLIC_port(bus_to_plic_memory);
        bus.PLICtoBUS_port(plic_memory_to_bus);

        //(connecting interrupts to the core)
        innerCore.mSip_mip_port(MSIP_to_mip);
        clint.MSIP_port(MSIP_to_mip);
        innerCore.mTip_mip_port(MTIP_to_mip);
        clint.MTIP_port(MTIP_to_mip);
        innerCore.mEip_mip_port(MEIP_to_mip);
        plic.MEIP_port(MEIP_to_mip);
    }

};

#endif //RISCV_CORE_H