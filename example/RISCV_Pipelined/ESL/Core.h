//
// Created by lukadejanovic on 20.3.18..
//

#ifndef PROJECT_CORE_H
#define PROJECT_CORE_H

#include "systemc.h"
#include "Interfaces.h"
#include "CPU_Interfaces.h"
#include "Control_path.h"
#include "Data_path.h"
#include "Register_file.h"
#include "../../RISCV_commons/Memory_Interfaces.h"


class Core : public sc_module {
public:

    //Constructor
    SC_HAS_PROCESS(Core);

    // Component instantiations
    Control_path CP;
    Data_path DP;
    Register_file RF;

    // Ports (Memory Interface)
    blocking_out<CUtoME_IF> COtoME_port;
    blocking_in<MEtoCP_IF> MEtoCO_port;

    // Channel instantiation
    MasterSlave<CPtoDP_IF> CPtoDP_channel;
    MasterSlave<DPtoCP_IF> DPtoCP_channel;

    MasterSlave<DPtoRF_IF> DPtoRF_channel;
    MasterSlave<RFtoDP_IF> RFtoDP_channel;

    Core(sc_module_name name) :
            CP("CP"),
            DP("DP"),
            RF("RF"),
            COtoME_port("COtoME_port"),
            MEtoCO_port("MEtoCO_port"),
            CPtoDP_channel("CPtoDP_channel"),
            DPtoCP_channel("DPtoCP_channel"),
            DPtoRF_channel("DPtoRF_channel"),
            RFtoDP_channel("RFtoDP_channel")
    {
        // Control path ports (memory interface) forwarded to outside
        CP.CPtoME_port(COtoME_port);
        CP.MEtoCP_port(MEtoCO_port);

        // Port binding:
        CP.CPtoDP_port(CPtoDP_channel);
        DP.CPtoDP_port(CPtoDP_channel);
        DP.DPtoCP_port(DPtoCP_channel);
        CP.DPtoCP_port(DPtoCP_channel);

        DP.DPtoRF_port(DPtoRF_channel);
        RF.DPtoRF_port(DPtoRF_channel);
        RF.RFtoDP_port(RFtoDP_channel);
        DP.RFtoDP_port(RFtoDP_channel);
    }
};

#endif //PROJECT_CORE_H