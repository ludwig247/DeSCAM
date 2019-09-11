//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 13.10.18.
//

#ifndef RISCV_INNERCORE_H_
#define RISCV_INNERCORE_H_

#include "systemc.h"
#include "Interfaces.h"
#include "CPU_Interfaces.h"
#include "ISA.h"
#include "regs.h"
#include "mip.h"
#include "SYScallHandler.h"
#include "InnerBus.h"


class InnerCore : public sc_module {
public:
    // Constructor
    SC_HAS_PROCESS(InnerCore);

    // Ports (Memory Interface)
    blocking_out<CUtoME_IF> COtoME_port;
    blocking_in<MEtoCU_IF> MEtoCO_port;

    // Ports (Interrupts Interface)
    master_in<bool> mSip_mip_port;
    master_in<bool> mTip_mip_port;
    master_in<bool> mEip_mip_port;
#ifdef CoreTempSensor_ON
    master_in<bool> mL12i_mip_port;
#endif

    // Components
    ISA ISA_inst;
    Regs RF;
    Mip mip;
    SYScallHandler syscallHandler;
    InnerBus innerBus;

    // Inside Channels (ISA_REG)
    MasterSlave<RegfileWriteType> ISAtoRF_channel;
    MasterSlave<RegfileType> RFtoISA_channel;

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

    InnerCore(sc_module_name name) :
            ISA_inst("isa"),
            RF("RF"),
            mip("mip"),
            syscallHandler("syscallHandler"),
            innerBus("innerBus"),
            ISAtoRF_channel("ISAtoRF_channel"),
            RFtoISA_channel("RFtoISA_channel"),
            syscall_reg_Channel("syscall_reg_Channel"),
            reg_syscall_Channel("reg_syscall_Channel"),
            isa_syscall_Channel("isa_syscall_Channel"),
            syscall_isa_Channel("syscall_isa_Channel"),
            isa_bus_Channel("isa_bus_Channel"),
            bus_isa_Channel("bus_isa_Channel"),
            syscall_bus_Channel("syscall_bus_Channel"),
            bus_syscall_Channel("bus_syscall_Channel"),
            mip_isa_Channel("mip_isa_Channel"),
            mSip_mip_port("mSip_mip_port"),
            mTip_mip_port("mTip_mip_port"),
            mEip_mip_port("mEip_mip_port"),
#ifdef CoreTempSensor_ON
            mL12i_mip_port("mL12i_mip_port"),
#endif
            COtoME_port("COtoME_port"),
            MEtoCO_port("MEtoCO_port")
    {

        // Module port binding: (ISA_REG)
        ISA_inst.RFtoISA_port(RFtoISA_channel);
        RF.RFtoISA_port(RFtoISA_channel);
        ISA_inst.ISAtoRF_port(ISAtoRF_channel);
        RF.ISAtoRF_port(ISAtoRF_channel);

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
        ISA_inst.COtoME_port(isa_bus_Channel);
        innerBus.isa_bus_Port(isa_bus_Channel);
        ISA_inst.MEtoCO_port(bus_isa_Channel);
        innerBus.bus_isa_Port(bus_isa_Channel);

        // Module port binding: (SYSCALL_BUS)
        syscallHandler.COtoME_port(syscall_bus_Channel);
        innerBus.syscall_bus_Port(syscall_bus_Channel);
        syscallHandler.MEtoCO_port(bus_syscall_Channel);
        innerBus.bus_syscall_Port(bus_syscall_Channel);

        // Module port binding: (ISA_MIP)
        ISA_inst.mip_isa_Port(mip_isa_Channel);
        mip.mip_isa_Port(mip_isa_Channel);

        // Memory interface forwarded to outside
        innerBus.COtoME_port(COtoME_port);
        innerBus.MEtoCO_port(MEtoCO_port);

        // Interrupts interface forwarded to mip
        mip.MSIP_port(mSip_mip_port);
        mip.MTIP_port(mTip_mip_port);
        mip.MEIP_port(mEip_mip_port);
#ifdef CoreTempSensor_ON
        mip.ML12I_port(mL12i_mip_port);
#endif
    }
};

#endif //RISCV_INNERCORE_H_