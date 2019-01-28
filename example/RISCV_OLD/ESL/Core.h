//
// Created by lukadejanovic on 20.3.18..
//

#ifndef PROJECT_RISCV_H
#define PROJECT_RISCV_H


#include "systemc.h"
#include "Interfaces.h"
#include "CPU_Interfaces.h"
#include "ALU.h"
#include "cpath.h"
#include "regs.h"
#include "Decoder.h"

class Core : public sc_module {
public:

    //Constructor

    // Ports (Memory Interface)
    blocking_out<CUtoME_IF> COtoME_port;
    blocking_in<MEtoCP_IF> MEtoCO_port;

    // Components
    ALU alu;
    Decoder decoder;
    Regs RF;
    Cpath cpath;

    // Channels
    Blocking<unsigned int> control_to_decoder;
    Blocking<DecodedInstr> decoder_to_control;

    Blocking<CtlToRegs_IF> CtlToRegs_channel;
    Blocking<RegsToCtl_IF> RegsToCtl_channel;

    Blocking<ALUtoCtl_IF> ALUtoCtl_channel;
    Blocking<CtlToALU_IF> CtlToALU_channel;


    Core(sc_module_name name) :
            alu("alu"),
            decoder("decoder"),
            RF("RF"),
            cpath("cpath"),
            control_to_decoder("memory_to_decoder"),
            decoder_to_control("decoder_to_control"),
            CtlToRegs_channel("CtlToRegs_channel"),
            RegsToCtl_channel("RegsToCtl_channel"),
            ALUtoCtl_channel("ALUtoCtl_channel"),
            CtlToALU_channel("CtlToALU_channel"),
            COtoME_port("core_out"),
            MEtoCO_port("core_in") {


        // Module port binding:
        cpath.CtlToDec_port(control_to_decoder);
        decoder.CtlToDec_port(control_to_decoder);
        decoder.DecToCtl_port(decoder_to_control);
        cpath.DecToCtl_port(decoder_to_control);

        cpath.RegsToCtl_port(RegsToCtl_channel);
        RF.RegsToCtl_port(RegsToCtl_channel);
        cpath.CtlToRegs_port(CtlToRegs_channel);
        RF.CtlToRegs_port(CtlToRegs_channel);

        alu.CtlToALU_port(CtlToALU_channel);
        cpath.CtlToALU_port(CtlToALU_channel);
        alu.ALUtoCtl_port(ALUtoCtl_channel);
        cpath.ALUtoCtl_port(ALUtoCtl_channel);


        // cpath ports (memory interface) forwarded to outside
        cpath.CtlToMem_port(COtoME_port);
        cpath.MemToCtl_port(MEtoCO_port);
    }
};


#endif //PROJECT_RISCV_H