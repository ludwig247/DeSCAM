//
// Created by paulius on 06.14.18.
//

#ifndef RISCV_CORE_H_
#define RISCV_CORE_H_


#include "systemc.h"
#include "../../Interfaces/Interfaces.h"
#include "CPU_Interfaces.h"
#include "ISA_ri5cy.h"
#include "regs_new.h"
#include "IMEM_ctrl.h"

#define REGFILE(x) RF.reg_file_##x
#define PCREG isa.pcReg

class Core : public sc_module {
public:
    // Constructor
    SC_HAS_PROCESS(Core);

    // Ports (Memory Interface)
    blocking_out<CUtoME_IF> COtoME_port;
    blocking_in<MEtoCU_IF> MEtoCO_port;

    // Components
    ISA_ri5cy isa;
    Regs_new RF;
    IMEM_ctrl imem;

    MasterSlave<RegfileWriteType> toRegsChannel;
    MasterSlave<RegfileType> fromRegsChannel;

    MasterSlave<unsigned int> toIMEMChannel;
    MasterSlave<unsigned int> fromIMEMChannel;

    Blocking<CUtoME_IF> toDMEMChannel;
    MasterSlave<unsigned int> fromDMEMChannel;

    Core(sc_module_name name) :
            isa("isa"),
            RF("RF"),
            imem("imem"),
            toRegsChannel("toRegsChannel"),
            fromRegsChannel("fromRegsChannel"),
            COtoME_port("coreOutPort"),
            MEtoCO_port("coreInPort"),
            toIMEMChannel("toIMEMChannel"),
            fromIMEMChannel("fromIMEMChannel"),
            toDMEMChannel("toDMEMChannel"),
            fromDMEMChannel("fromDMEMChannel")
    {

        // Module port binding:
        isa.fromRegsPort(fromRegsChannel);
        RF.fromRegsPort(fromRegsChannel);
        isa.toRegsPort(toRegsChannel);
        RF.toRegsPort(toRegsChannel);

        // Instr Memory and CPU interface
        isa.instr_in(fromIMEMChannel);
        imem.toCPUPort(fromIMEMChannel);
        isa.instr_req(toIMEMChannel);
        imem.fromCPUPort(toIMEMChannel);


        //Data Memory and CPU interface
        isa.data_in(fromDMEMChannel);
        imem.dataToCPUPort(fromDMEMChannel);
        isa.data_out(toDMEMChannel);
        imem.dataFromCPUPort(toDMEMChannel);

        //Memory Interface
        imem.fromMemoryPort(MEtoCO_port);
        imem.toMemoryPort(COtoME_port);
    }
};

#endif //RISCV_CORE_H_