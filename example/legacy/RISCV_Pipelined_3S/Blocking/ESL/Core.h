//
// Created by salaheddin hetalani (salaheddinhetalani@gmail.com) on 16 Jan, 2019
//

#ifndef PROJECT_CORE_H
#define PROJECT_CORE_H

#include "systemc.h"
#include "Interfaces.h"
#include "CPU_Interfaces.h"
#include "Control_unit.h"
#include "Register_file.h"
#include "../../RISCV_commons/Memory_Interfaces.h"


class Core : public sc_module {
public:

    //Constructor
    SC_HAS_PROCESS(Core);

    // Component instantiations
    Control_unit CU;
    Register_file RF;

    // Ports (Memory Interface)
    blocking_out<CUtoME_IF> COtoME_port;
    blocking_in<MEtoCU_IF> MEtoCO_port;

    // Channel instantiation
    MasterSlave<CUtoRF_IF> CUtoRF_channel;
    MasterSlave<RFtoCU_IF> RFtoCU_channel;

    Core(sc_module_name name) :
            CU("CU"),
            RF("RF"),
            COtoME_port("COtoME_port"),
            MEtoCO_port("MEtoCO_port"),
            CUtoRF_channel("CUtoRF_channel"),
            RFtoCU_channel("RFtoCU_channel")
    {
        // Control unit ports (memory interface) forwarded to outside
        CU.CUtoME_port(COtoME_port);
        CU.MEtoCU_port(MEtoCO_port);

        // Port binding:
        CU.CUtoRF_port(CUtoRF_channel);
        RF.CUtoRF_port(CUtoRF_channel);
        RF.RFtoCU_port(RFtoCU_channel);
        CU.RFtoCU_port(RFtoCU_channel);
    }
};


#endif //PROJECT_CORE_H