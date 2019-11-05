//
// Created by paulius on 06.14.18.
//

#ifndef RISCV_CORE_H_
#define RISCV_CORE_H_


#include "systemc.h"
#include "Interfaces.h"
#include "CPU_Interfaces.h"
#include "Decoder.h"
#include "ISA.h"
#include "regs.h"

#define REGFILE(x) RF.reg_file_##x
#define PCREG isa.pc_reg

class Core : public sc_module {
public:
    // Constructor
    SC_HAS_PROCESS(Core);

    // Ports (Memory Interface)
    blocking_out<CUtoME_IF> COtoME_port;
    blocking_in<MEtoCU_IF> MEtoCO_port;

    // Components
    Decoder decoder;
    ISA isa;
    Regs RF;

    // Channels
    MasterSlave<unsigned int> control_to_decoder;
    MasterSlave<DecodedInstr> decoder_to_control;

    MasterSlave<CtlToRegs_IF> CtlToRegs_channel;
    MasterSlave<RegsToCtl_IF> RegsToCtl_channel;

    Core(sc_module_name name) :
            decoder("decoder"),
            isa("isa"),
            RF("RF"),
            control_to_decoder("memory_to_decoder"),
            decoder_to_control("decoder_to_control"),
            CtlToRegs_channel("CtlToRegs_channel"),
            RegsToCtl_channel("RegsToCtl_channel"),
            COtoME_port("core_out"),
            MEtoCO_port("core_in") {


        // Module port binding:
        isa.CtlToDec_port(control_to_decoder);
        decoder.CtlToDec_port(control_to_decoder);
        isa.DecToCtl_port(decoder_to_control);
        decoder.DecToCtl_port(decoder_to_control);

        isa.RegsToCtl_port(RegsToCtl_channel);
        RF.RegsToCtl_port(RegsToCtl_channel);
        isa.CtlToRegs_port(CtlToRegs_channel);
        RF.CtlToRegs_port(CtlToRegs_channel);

        // Memory interface forwarded to outside
        isa.CtlToMem_port(COtoME_port);
        isa.MemToCtl_port(MEtoCO_port);
    }
};

#endif //RISCV_CORE_H_
