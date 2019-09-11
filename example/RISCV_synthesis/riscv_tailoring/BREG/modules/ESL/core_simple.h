#ifndef RISCV_CORE_H_
#define RISCV_CORE_H_

#include "systemc.h"
#include "Interfaces.h"
#include "CPU_Interfaces.h"
#include "regs.h"
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

    MasterSlave<RegfileWriteType> ISAtoRF_channel;
    MasterSlave<RegfileType> RFtoISA_channel;

    Core(sc_module_name name) :
            ISA_inst("ISA"),
            RF("RF"),
            ISAtoRF_channel("ISAtoRF_channel"),
            RFtoISA_channel("RFtoISA_channel"),
            COtoME_port("COtoME_port"),
            MEtoCO_port("MEtoCO_port") {

        // Module port binding:
        ISA_inst.RFtoISA_port(RFtoISA_channel);
        RF.RFtoISA_port(RFtoISA_channel);
        ISA_inst.ISAtoRF_port(ISAtoRF_channel);
        RF.ISAtoRF_port(ISAtoRF_channel);

        // Memory interface forwarded to outside
        ISA_inst.COtoME_port(COtoME_port);
        ISA_inst.MEtoCO_port(MEtoCO_port);
    }
};
#endif //RISCV_CORE_H_
