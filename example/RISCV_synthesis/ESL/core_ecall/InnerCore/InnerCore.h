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

    // Components
    ISA ISA_inst;
    Regs RF;
    Mip mip;

    // Inside Channels (ISA_REG)
    MasterSlave<RegfileWriteType> ISAtoRF_channel;
    MasterSlave<RegfileType> RFtoISA_channel;

    // Inside Channels (ISA_MIP)
    MasterSlave<unsigned int> mip_isa_Channel;

    InnerCore(sc_module_name name) :
            ISA_inst("isa"),
            RF("RF"),
            mip("mip"),
            ISAtoRF_channel("ISAtoRF_channel"),
            RFtoISA_channel("RFtoISA_channel"),
            mip_isa_Channel("mip_isa_Channel"),
            mSip_mip_port("mSip_mip_port"),
            mTip_mip_port("mTip_mip_port"),
            mEip_mip_port("mEip_mip_port"),
            COtoME_port("COtoME_port"),
            MEtoCO_port("MEtoCO_port")
    {

        // Module port binding: (ISA_REG)
        ISA_inst.RFtoISA_port(RFtoISA_channel);
        RF.RFtoISA_port(RFtoISA_channel);
        ISA_inst.ISAtoRF_port(ISAtoRF_channel);
        RF.ISAtoRF_port(ISAtoRF_channel);

        // Module port binding: (ISA_MIP)
        ISA_inst.mip_isa_Port(mip_isa_Channel);
        mip.mip_isa_Port(mip_isa_Channel);

        // Memory interface forwarded to outside
        ISA_inst.COtoME_port(COtoME_port);
        ISA_inst.MEtoCO_port(MEtoCO_port);

        // Interrupts interface forwarded to mip
        mip.MSIP_port(mSip_mip_port);
        mip.MTIP_port(mTip_mip_port);
        mip.MEIP_port(mEip_mip_port);
    }
};

#endif //RISCV_INNERCORE_H_