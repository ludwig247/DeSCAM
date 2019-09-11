//
// Created by salaheddin hetalani (salaheddinhetalani@gmail.com) on 31 Mar, 2018
//

#ifndef PROJECT_CORE_H
#define PROJECT_CORE_H

#include "systemc.h"
#include "Interfaces.h"
#include "CPU_Interfaces.h"
#include "Control_unit.h"
#include "Data_path.h"
#include "Register_file.h"
#include "../../RISCV_commons/Memory_Interfaces.h"


class Core : public sc_module {
public:

    //Constructor
    SC_HAS_PROCESS(Core);

    // Component instantiations
    Control_unit CU;
    Data_path DP;
    Register_file RF;

    // Ports (Memory Interface)
    blocking_out<CUtoME_IF> COtoME_port;
    blocking_in<MEtoCU_IF> MEtoCO_port;

    // Channel instantiation
    MasterSlave<CUtoDP_IF> CUtoDP_channel;
    MasterSlave<DPtoCU_IF> DPtoCU_channel;

    MasterSlave<DPtoRF_IF> DPtoRF_channel;
    MasterSlave<RFtoDP_IF> RFtoDP_channel;

    Core(sc_module_name name) :
            CU("CU"),
            DP("DP"),
            RF("RF"),
            COtoME_port("COtoME_port"),
            MEtoCO_port("MEtoCO_port"),
            CUtoDP_channel("CUtoDP_channel"),
            DPtoCU_channel("DPtoCU_channel"),
            DPtoRF_channel("DPtoRF_channel"),
            RFtoDP_channel("RFtoDP_channel")
    {
        // Control unit ports (memory interface) forwarded to outside
        CU.CUtoME_port(COtoME_port);
        CU.MEtoCU_port(MEtoCO_port);

        // Port binding:
        CU.CUtoDP_port(CUtoDP_channel);
        DP.CUtoDP_port(CUtoDP_channel);
        DP.DPtoCU_port(DPtoCU_channel);
        CU.DPtoCU_port(DPtoCU_channel);

        DP.DPtoRF_port(DPtoRF_channel);
        RF.DPtoRF_port(DPtoRF_channel);
        RF.RFtoDP_port(RFtoDP_channel);
        DP.RFtoDP_port(RFtoDP_channel);
    }
};


#endif //PROJECT_CORE_H