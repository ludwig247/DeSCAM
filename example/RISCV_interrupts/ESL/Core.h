//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 13.10.18.
//

#ifndef RISCV_CORE_H
#define RISCV_CORE_H

// Adjusts code to be appropriate for the SCAM tool
// Working ESL-Description -> #define NOSCAM
// Properties can be generated -> //#define NOSCAM
//#define NOSCAM

#ifdef NOSCAM
#include "../../RISCV_commons/Memory_Interfaces.h"
#endif


#define CoreTempSensor_ON

#include "systemc.h"
#include "Interfaces.h"
#include "Defines.h"
#include "CPU_Interfaces.h"
#include "ISA.h"
#include "regs.h"
#include "mip.h"
#include "SYScallHandler.h"

#include "Bus.h"
#include "CLINT.h"
#include "PLIC.h"
#ifdef CoreTempSensor_ON
#include "CoreTempSensor.h"
#endif

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
    MasterSlave<bool> MEIP_to_mip;
    // Components
    ISA ISA_inst;
    Regs RF;
    Mip mip;
    SYScallHandler syscallHandler;
    Bus bus;
    CLINT clint;
    PLIC plic;
#ifdef CoreTempSensor_ON
    CoreTempSensor coreTempSensor;
    // interrupt connection
    MasterSlave<bool> ML12I_to_mip;
    //(connecting bus to terminal memory)
    Blocking<CUtoME_IF> bus_to_coreTempSensor_memory;
    Blocking<MEtoCU_IF> coreTempSensor_memory_to_bus;
#endif
    // Channels
    // Inside Channels (ISA_REG)
    MasterSlave<RegfileWriteType> toRegsChannel;
    MasterSlave<RegfileType> fromRegsChannel;

    // Inside Channels (SYSCALL_REG)
    MasterSlave<RegfileWriteType> syscall_reg_Channel;
    MasterSlave<RegfileSyscallType> reg_syscall_Channel;

    // Inside Channels (ISA_SYSCALL)
    Blocking<bool> isa_syscall_Channel;
    Blocking<bool> syscall_isa_Channel;

    // Inside Channels (ISA_BUS)
    Blocking<CUtoME_IF> isa_bus_Channel;
    Blocking<MEtoCU_IF> bus_isa_Channel;

    // Inside Channels (SYSCALL_BUS)
    Blocking<CUtoME_IF> syscall_bus_Channel;
    Blocking<MEtoCU_IF> bus_syscall_Channel;

    // Inside Channels (ISA_MIP)
    MasterSlave<unsigned int> mip_isa_Channel;

    //(connecting bus to clint memory)
    Blocking<CUtoME_IF> bus_to_clint_memory;
    Blocking<MEtoCU_IF> clint_memory_to_bus;
    //(connecting bus to plic memory)
    Blocking<CUtoME_IF> bus_to_plic_memory;
    Blocking<MEtoCU_IF> plic_memory_to_bus;

    Core(sc_module_name name) :
            ISA_inst("isa"),
            RF("RF"),
            mip("mip"),
            syscallHandler("syscallHandler"),
            bus("bus"),
            clint("clint"),
            plic("plic"),
#ifdef CoreTempSensor_ON
            coreTempSensor("coreTempSensor"),
            bus_to_coreTempSensor_memory("bus_to_coreTempSensor_memory"),
            coreTempSensor_memory_to_bus("coreTempSensor_memory_to_bus"),
            ML12I_to_mip("ML12I_to_mip"),
#endif
            COtoME_port("core_out"),
            MEtoCO_port("core_in"),
            toRegsChannel("toRegsChannel"),
            fromRegsChannel("fromRegsChannel"),
            syscall_reg_Channel("syscall_reg_Channel"),
            reg_syscall_Channel("reg_syscall_Channel"),
            isa_syscall_Channel("isa_syscall_Channel"),
            syscall_isa_Channel("syscall_isa_Channel"),
            isa_bus_Channel("isa_bus_Channel"),
            bus_isa_Channel("bus_isa_Channel"),
            syscall_bus_Channel("syscall_bus_Channel"),
            bus_syscall_Channel("bus_syscall_Channel"),
            mip_isa_Channel("mip_isa_Channel"),
            bus_to_clint_memory("bus_to_clint_memory"),
            clint_memory_to_bus("clint_memory_to_bus"),
            bus_to_plic_memory("bus_to_plic_memory"),
            plic_memory_to_bus("plic_memory_to_bus"),
            MSIP_to_mip("MSIP_to_mip"),
            MTIP_to_mip("MTIP_to_mip"),
            MEIP_to_mip("MEIP_to_mip") {
        ////////////// Channel instantiation
        //(connecting inner core to bus)
        // Module port binding: (ISA_REG)
        ISA_inst.fromRegsPort(fromRegsChannel);
        RF.fromRegsPort(fromRegsChannel);
        ISA_inst.toRegsPort(toRegsChannel);
        RF.toRegsPort(toRegsChannel);

        // Module port binding: (SYSCALL_REG)
        syscallHandler.reg_syscall_Port(reg_syscall_Channel);
        RF.reg_syscall_Port(reg_syscall_Channel);
        syscallHandler.syscall_reg_Port(syscall_reg_Channel);
        RF.syscall_reg_Port(syscall_reg_Channel);

        // Module port binding: (ISA_SYSCALL)
        ISA_inst.isa_syscall_Port(isa_syscall_Channel);
        syscallHandler.isa_syscall_Port(isa_syscall_Channel);
        ISA_inst.syscall_isa_Port(syscall_isa_Channel);
        syscallHandler.syscall_isa_Port(syscall_isa_Channel);

        // Module port binding: (ISA_BUS)
        ISA_inst.toMemoryPort(isa_bus_Channel);
        bus.isa_bus_Port(isa_bus_Channel);
        ISA_inst.fromMemoryPort(bus_isa_Channel);
        bus.bus_isa_Port(bus_isa_Channel);

        // Module port binding: (SYSCALL_BUS)
        syscallHandler.toMemoryPort(syscall_bus_Channel);
        bus.syscall_bus_Port(syscall_bus_Channel);
        syscallHandler.fromMemoryPort(bus_syscall_Channel);
        bus.bus_syscall_Port(bus_syscall_Channel);

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

        //(connecting bus to plic memory)
        plic.COtoME_port(bus_to_plic_memory);
        plic.MEtoCO_port(plic_memory_to_bus);
        bus.BUStoPLIC_port(bus_to_plic_memory);
        bus.PLICtoBUS_port(plic_memory_to_bus);

#ifdef CoreTempSensor_ON
        //(connecting bus to coreTempSensor memory)
        coreTempSensor.COtoME_port(bus_to_coreTempSensor_memory);
        coreTempSensor.MEtoCO_port(coreTempSensor_memory_to_bus);
        bus.BUStoCoreTempSensor_port(bus_to_coreTempSensor_memory);
        bus.CoreTempSensortoBUS_port(coreTempSensor_memory_to_bus);
        mip.ML12I_port(ML12I_to_mip);
        coreTempSensor.ML12I_port(ML12I_to_mip);
#endif

        //(connecting interrupts to the core)
        mip.MSIP_port(MSIP_to_mip);
        clint.MSIP_port(MSIP_to_mip);
        mip.MTIP_port(MTIP_to_mip);
        clint.MTIP_port(MTIP_to_mip);
        mip.MEIP_port(MEIP_to_mip);
        plic.MEIP_port(MEIP_to_mip);
    }

};

#endif //RISCV_CORE_H