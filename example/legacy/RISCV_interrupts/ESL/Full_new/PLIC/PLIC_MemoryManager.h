//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 11/22/18.
//

#ifndef PROJECT_PLIC_MEMORYMANAGER_H
#define PROJECT_PLIC_MEMORYMANAGER_H


// Adjusts code to be appropriate for the SCAM tool
// Working ESL-Description -> //#define SCAM
// Properties can be generated -> #define SCAM
//#define SCAM

#include "systemc.h"
//#include "Interfaces.h"
#include "../../../../RISCV_commons/Memory_Interfaces.h"
#include "../../../../RISCV_commons/Defines.h"


class PLIC_Memory_Manager : public sc_module {
public:

    //Constructor
    SC_HAS_PROCESS(PLIC_Memory_Manager);

    PLIC_Memory_Manager(sc_module_name name) :
            COtoME_port("COtoME_port"),
            MEtoCO_port("MEtoCO_port"),
            toCore_Priority_Int_1("toCore_Priority_Int_1"),
            toCore_Priority_Int_2("toCore_Priority_Int_2"),
            toCore_Enabled("toCore_Enabled"),
            toCore_Threshold("toCore_Threshold"),
            toCore_Claimed("toCore_Claimed"),
//            fromCore_MaxPriority("fromCore_MaxPriority"),
            fromCore_MaxID("fromCore_MaxID"),
            priority_Int_1_data(0),
            priority_Int_2_data(0),
            enabled_data(0),
            threshold_data(0),
//            max_priority_data(0),
            max_id_data(0),
            ClaimComplete(0),
            toGatewayPending_1("toGatewayPending_1"),
            toGatewayPending_2("toGatewayPending_2") {
        SC_THREAD(run);
    }

    /// Communication and data with Core
    blocking_in<CUtoME_IF> COtoME_port; // load/store
    blocking_out<MEtoCU_IF> MEtoCO_port; // store/load done

    CUtoME_IF CPtoME_data;
    MEtoCU_IF MEtoCP_data;

    /// Communication and data with PLIC_Core
    shared_out<unsigned int> toCore_Priority_Int_1;
    shared_out<unsigned int> toCore_Priority_Int_2;
    shared_out<unsigned int> toCore_Enabled;
    shared_out<unsigned int> toCore_Threshold;
    master_out<unsigned int> toCore_Claimed;
//    shared_out<unsigned int> toCore_Claimed;
    shared_in<unsigned int> fromCore_MaxID;

    unsigned int priority_Int_1_data;
    unsigned int priority_Int_2_data;
    unsigned int enabled_data;
    unsigned int threshold_data;
//    unsigned int max_priority_data;
    unsigned int max_id_data;

    unsigned int ClaimComplete;


    /// Communication and data with PLIC_Gateways
    master_out<bool> toGatewayPending_1;
    master_out<bool> toGatewayPending_2;


    void run() {
        while (true) {
            toCore_Priority_Int_1->set(priority_Int_1_data);
            toCore_Priority_Int_2->set(priority_Int_2_data);
            toCore_Enabled->set(enabled_data);
            toCore_Threshold->set(threshold_data);

            /// start with a memory request
            MEtoCP_data.loadedData = 0;
            COtoME_port->read(CPtoME_data); //Wait for next request

            /// get the most recent values from PLIC_Core
//            fromCore_MaxPriority->read(max_priority_data);
            fromCore_MaxID->get(max_id_data);
            if(max_id_data != ClaimComplete)
                ClaimComplete = max_id_data;

            if (CPtoME_data.addrIn < PLIC_START_ADDR && CPtoME_data.addrIn > PLIC_END_ADDR) {
#ifndef SCAM
                cout << "@PLIC: Accessing out of bound. Terminating!" << endl;
                sc_stop();
                wait(WAIT_TIME, SC_PS);
//                wait(SC_ZERO_TIME);
#endif
            }

            if (CPtoME_data.req == ME_RD) { // LOAD
                if (CPtoME_data.addrIn == PLIC_Priority_ADDR) {
                    MEtoCP_data.loadedData = priority_Int_1_data;
                    MEtoCO_port->write(MEtoCP_data);
                } else if (CPtoME_data.addrIn == PLIC_Priority_ADDR + 4) {
                    MEtoCP_data.loadedData = priority_Int_2_data;
                    MEtoCO_port->write(MEtoCP_data);
                } else if (CPtoME_data.addrIn == PLIC_Interrupt_Enables_ADDR) {
                    MEtoCP_data.loadedData = enabled_data;
                    MEtoCO_port->write(MEtoCP_data);
                } else if (CPtoME_data.addrIn == PLIC_Threshold_ADDR) {
                    MEtoCP_data.loadedData = threshold_data;
                    MEtoCO_port->write(MEtoCP_data);
                } else if (CPtoME_data.addrIn == PLIC_Claim_Complete_ADDR) {
                    MEtoCP_data.loadedData = ClaimComplete;
                    /// Let PLIC_Core know immediately that a pending interrupt has been claimed
                    toCore_Claimed->master_write(ClaimComplete);
                    MEtoCO_port->write(MEtoCP_data);
                } else {
#ifndef SCAM
                    cout << "@PLIC: Unauthorized read. Terminating!" << hex << CPtoME_data.addrIn << endl;
                    sc_stop();
                    wait(WAIT_TIME, SC_PS);
//                wait(SC_ZERO_TIME);
#endif
                }
            } else if (CPtoME_data.req == ME_WR) {
                if (CPtoME_data.addrIn == PLIC_Priority_ADDR) {
                    priority_Int_1_data = CPtoME_data.dataIn;
                } else if (CPtoME_data.addrIn == PLIC_Priority_ADDR + 4) {
                    priority_Int_2_data = CPtoME_data.dataIn;
                } else if (CPtoME_data.addrIn == PLIC_Pending_ADDR) {
                    toGatewayPending_1->master_write(true);
                } else if (CPtoME_data.addrIn == PLIC_Pending_ADDR + 4) {
                    toGatewayPending_2->master_write(true);
                } else if (CPtoME_data.addrIn == PLIC_Interrupt_Enables_ADDR) {
                    enabled_data = CPtoME_data.dataIn;
                } else if (CPtoME_data.addrIn == PLIC_Threshold_ADDR) {
                    threshold_data = CPtoME_data.dataIn;
                } else if (CPtoME_data.addrIn == PLIC_Claim_Complete_ADDR) {
                    ClaimComplete = CPtoME_data.dataIn;
                } else {

#ifndef SCAM
                    cout << "@PLIC: Unauthorized write. Terminating!" << hex << CPtoME_data.addrIn << endl;
                    sc_stop();
                    wait(WAIT_TIME, SC_PS);
//                wait(SC_ZERO_TIME);
#endif
                }
            } else {
#ifndef SCAM
                throw std::logic_error(std::string("@PLIC: Undefined memory's req value."));
#endif
            }
        }
    }
};

#endif //PROJECT_PLIC_MEMORYMANAGER_H
