//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 13.10.18.
//

/*
 * Platform Level Interrupt Controller (PLIC)
 * Used to prioritizes and distributes global interrupts
 */

#ifndef PROJECT_PLIC_H
#define PROJECT_PLIC_H

#include "systemc.h"
#include "Interfaces.h"
#include "Memory_Interfaces.h"
#include "Defines.h"
#include "PLIC_MemoryManager.h"
#include "PLIC_Core.h"
#include "PLIC_Gateways.h"

class PLIC : public sc_module {
public:
    //Components
    PLIC_Gateways plic_gateways;
    PLIC_Core plic_core;
    PLIC_Memory_Manager plic_memoryManager;

    //Constructor
    SC_HAS_PROCESS(PLIC);

    /// Communication with Core
    blocking_in<CUtoME_IF> COtoME_port;
    blocking_out<MEtoCU_IF> MEtoCO_port;
    slave_out<bool> MEIP_port;

    /// Communication between Gateway and Core
    MasterSlave<bool> IntReq_1;
    MasterSlave<bool> IntReq_2;

    /// Communication between Gateway and Memory Manager
    MasterSlave<bool> Pending_1;
    MasterSlave<bool> Pending_2;

    /// Communication between Core and Memory Manager
    Shared<unsigned int> MEtoCO_Priority_Int_1;
    Shared<unsigned int> MEtoCO_Priority_Int_2;
    Shared<unsigned int> MEtoCO_Enabled;
    Shared<unsigned int> MEtoCO_Threshold;
    MasterSlave<unsigned int> MEtoCO_Claimed;
//    MasterSlave<unsigned int> MEtoCO_MaxPriority;
    Shared<unsigned int> MEtoCO_MaxID;

    PLIC(sc_module_name name) :
            plic_gateways("plic_gateways"),
            plic_core("plic_core"),
            plic_memoryManager("plic_memoryManager"),

            IntReq_1("IntReq_1"),
            IntReq_2("IntReq_2"),

            Pending_1("Pending_1"),
            Pending_2("Pending_2"),

            MEtoCO_Priority_Int_1("MEtoCO_Priority_Int_1"),
            MEtoCO_Priority_Int_2("MEtoCO_Priority_Int_2"),
            MEtoCO_Enabled("MEtoCO_Enabled"),
            MEtoCO_Threshold("MEtoCO_Threshold"),
            MEtoCO_Claimed("MEtoCO_Claimed"),
//            MEtoCO_MaxPriority("MEtoCO_MaxPriority"),
            MEtoCO_MaxID("MEtoCO_MaxID"),

            MEIP_port("MEIP_port"),
            COtoME_port("COtoME_port"),
            MEtoCO_port("MEtoCO_port") {

        plic_gateways.IntReq_1(IntReq_1);
        plic_gateways.IntReq_2(IntReq_2);
        plic_core.fromGateway_Int1(IntReq_1);
        plic_core.fromGateway_Int2(IntReq_2);

        plic_gateways.fromMemoryPending_1(Pending_1);
        plic_gateways.fromMemoryPending_2(Pending_2);
        plic_memoryManager.toGatewayPending_1(Pending_1);
        plic_memoryManager.toGatewayPending_2(Pending_2);

        plic_memoryManager.toCore_Priority_Int_1(MEtoCO_Priority_Int_1);
        plic_memoryManager.toCore_Priority_Int_2(MEtoCO_Priority_Int_2);
        plic_memoryManager.toCore_Enabled(MEtoCO_Enabled);
        plic_memoryManager.toCore_Threshold(MEtoCO_Threshold);
        plic_memoryManager.toCore_Claimed(MEtoCO_Claimed);
//        plic_memoryManager.fromCore_MaxPriority(MEtoCO_MaxPriority);
        plic_memoryManager.fromCore_MaxID(MEtoCO_MaxID);

        plic_core.fromMemory_Priority_Int_1(MEtoCO_Priority_Int_1);
        plic_core.fromMemory_Priority_Int_2(MEtoCO_Priority_Int_2);
        plic_core.fromMemory_Enabled(MEtoCO_Enabled);
        plic_core.fromMemory_Threshold(MEtoCO_Threshold);
        plic_core.fromMemory_Claimed(MEtoCO_Claimed);
//        plic_core.toMemory_MaxPriority(MEtoCO_MaxPriority);
        plic_core.toMemory_MaxID(MEtoCO_MaxID);

        plic_memoryManager.COtoME_port(COtoME_port);
        plic_memoryManager.MEtoCO_port(MEtoCO_port);
        plic_core.MEIP_port(MEIP_port);
    }

};

#endif  // PROJECT_PLIC_H