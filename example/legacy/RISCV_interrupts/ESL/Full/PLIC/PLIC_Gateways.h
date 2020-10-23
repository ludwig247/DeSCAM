//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 11/22/18.
//

#ifndef PROJECT_PLIC_GATEWAYS_H
#define PROJECT_PLIC_GATEWAYS_H

#include "systemc.h"
#include "Interfaces.h"
#include "PLIC_source.h"
#include "PLIC_Gateway.h"

class PLIC_Gateways : public sc_module {
public:

    TheUNKNOWN sources;
    Gateway gateway_1;
    Gateway gateway_2;

    //Constructor
    SC_HAS_PROCESS(PLIC_Gateways);

    PLIC_Gateways(sc_module_name name) :
            sources("IntSources"),
            gateway_1("gateway_1"),
            gateway_2("gateway_2"),
            IntSig_1("IntSig_1"),
            IntReq_1("IntReq_1"),
            fromMemoryPending_1("fromMemoryPending_1"),
            IntSig_2("IntSig_2"),
            IntReq_2("IntReq_2"),
            fromMemoryPending_2("fromMemoryPending_2")
    {
        sources.IntSig_1(IntSig_1);
        sources.IntSig_2(IntSig_2);

        gateway_1.IntSig(IntSig_1);
        gateway_1.IntReq(IntReq_1);
        gateway_1.fromMemoryPending(fromMemoryPending_1);

        gateway_2.IntSig(IntSig_2);
        gateway_2.IntReq(IntReq_2);
        gateway_2.fromMemoryPending(fromMemoryPending_2);
    }

    MasterSlave<bool> IntSig_1;
    MasterSlave<bool> IntSig_2;
    master_out<bool> IntReq_1;
    master_out<bool> IntReq_2;
    slave_in<bool> fromMemoryPending_1;
    slave_in<bool> fromMemoryPending_2;
};

#endif //PROJECT_PLIC_GATEWAYS_H
