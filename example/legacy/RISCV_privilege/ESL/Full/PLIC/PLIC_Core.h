//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 11/22/18.
//

#ifndef PROJECT_PLIC_CORE_H
#define PROJECT_PLIC_CORE_H

#include "systemc.h"
#include "Interfaces.h"


class PLIC_Core : public sc_module {
public:

    //Constructor
    SC_HAS_PROCESS(PLIC_Core);

    PLIC_Core(sc_module_name name) :
            fromGateway_Int1("fromGateway_Int1"),
            fromGateway_Int2("fromGateway_Int2"),
            pending_Int_1_data(false),
            pending_Int_2_data(false),
            fromMemory_Priority_Int_1("fromMemory_Priority_Int_1"),
            fromMemory_Priority_Int_2("fromMemory_Priority_Int_2"),
            fromMemory_Enabled("fromMemory_Enabled"),
            fromMemory_Threshold("fromMemory_Threshold"),
            fromMemory_Claimed("fromMemory_Claimed"),
//            toMemory_MaxPriority("toMemory_MaxPriority"),
            toMemory_MaxID("toMemory_MaxID"),
            priority_Int_1_data(0),
            priority_Int_2_data(0),
            enabled_data(0),
            threshold_data(0),
            claimed_data(0),
            claimed_status(false),
            MEIP_port("MEIP_port"),
//            max_priority(0),
            max_id(0),
            traversing_priority(0),
            traversing_id(0) {
        SC_THREAD(run);
    }

    /// Communication and data with Gateway
    slave_in<bool> fromGateway_Int1;
    slave_in<bool> fromGateway_Int2;

    bool pending_Int_1_data;
    bool pending_Int_2_data;
    /// Communication and data with Memory
    shared_in<unsigned int> fromMemory_Priority_Int_1;
    shared_in<unsigned int> fromMemory_Priority_Int_2;
    shared_in<unsigned int> fromMemory_Enabled;
    shared_in<unsigned int> fromMemory_Threshold;
    slave_in<unsigned int> fromMemory_Claimed;
//    shared_in<unsigned int> fromMemory_Claimed;
    shared_out<unsigned int> toMemory_MaxID;

    unsigned int priority_Int_1_data;
    unsigned int priority_Int_2_data;
    unsigned int enabled_data;
    unsigned int threshold_data;
    unsigned int claimed_data;
    bool claimed_status;

    /// Communication with Core
    slave_out<bool> MEIP_port;

    /// Internal variables
//    unsigned int max_priority;
    unsigned int max_id;
    unsigned int traversing_priority;
    unsigned int traversing_id;

    void run(); // thread

    bool manageInt_Claim(bool pind_int, unsigned int pind_id, unsigned int claimed, bool claimed_status) const;
    unsigned int getPriority(unsigned int traverse_prio, unsigned int prio_1, unsigned int prio_2, unsigned int enabled, bool pind_1, bool pind_2) const;
    unsigned int getId(unsigned int traverse_prio, unsigned int traverse_id, unsigned int prio_1, unsigned int prio_2, unsigned int enabled, bool pind_1, bool pind_2) const;
};

void PLIC_Core::run() {
    while (true) {
        /// read configuration from memory manager
        fromMemory_Priority_Int_1->get(priority_Int_1_data);
        fromMemory_Priority_Int_2->get(priority_Int_2_data);
        fromMemory_Enabled->get(enabled_data);
        fromMemory_Threshold->get(threshold_data);

        /// clear a pending interrupt if it has been claimed by target
        claimed_status = fromMemory_Claimed->nb_read(claimed_data);
        pending_Int_1_data = manageInt_Claim(pending_Int_1_data, 1, claimed_data, claimed_status);
        pending_Int_2_data = manageInt_Claim(pending_Int_2_data, 2, claimed_data, claimed_status);

        /// read pending interrupts from gateway
        fromGateway_Int1->nb_read(pending_Int_1_data);
        fromGateway_Int2->nb_read(pending_Int_2_data);

        /// reset traversing variables to start a new round
        traversing_priority = getPriority(0, priority_Int_1_data, priority_Int_2_data, enabled_data, pending_Int_1_data, pending_Int_2_data);
        traversing_id = getId(0, 0, priority_Int_1_data, priority_Int_2_data, enabled_data, pending_Int_1_data, pending_Int_2_data);

        //FIXME: This section should be first in the design to avoid shared channel unpredictable initial value
        /// process final decision
        if (traversing_priority > threshold_data) {
            MEIP_port->nb_write(true);
//            max_priority = traversing_priority;
            max_id = traversing_id;
            toMemory_MaxID->set(max_id);
        } else {
            MEIP_port->nb_write(false);
            toMemory_MaxID->set(max_id);
        }


        /// PLIC_Core should always send the Memory manager the max_priority and max_id so that the target can have the option of "Pulling" the status of the PLIC
        /// instead of reacting solely to an interrupt trigger.
//        toMemory_MaxPriority->nb_write(max_priority);
//        toMemory_MaxID->nb_write(max_id);
//        pending_Int_1_data = pending_Int_1;
//        pending_Int_2_data = pending_Int_2;
    }
}

bool PLIC_Core::manageInt_Claim(bool pind_int, unsigned int pind_id, unsigned int claimed, bool claimed_status) const {
    if(claimed_status){
        if(claimed == 1 && pind_id == 1)
            return false;
        else if(claimed == 2 && pind_id == 2)
            return false;
        else
            return pind_int;
    } else
        return pind_int;
}

unsigned int PLIC_Core::getPriority(unsigned int traverse_prio, unsigned int prio_1, unsigned int prio_2, unsigned int enabled, bool pind_1, bool pind_2) const {

    /// process interrupt 1
    if (pind_1 && (enabled & 0x1)>0) {
        if(prio_1 > traverse_prio) {
            traverse_prio = prio_1;
        }
    }

    /// process interrupt 2
    if (pind_2 && (enabled & 0x2)>0) {
        if(prio_2 > traverse_prio) {
            traverse_prio = prio_2;
        }
    }

    return traverse_prio;
}

unsigned int PLIC_Core::getId(unsigned int traverse_prio, unsigned int traverse_id, unsigned int prio_1, unsigned int prio_2, unsigned int enabled, bool pind_1, bool pind_2) const {

    /// process interrupt 1
    if (pind_1 && (enabled & 0x1)>0) {
        if(prio_1 > traverse_prio) {
            traverse_prio = prio_1;
            traverse_id = 1;
        }
    }

    /// process interrupt 2
    if (pind_2 && (enabled & 0x2)>0) {
        if(prio_2 > traverse_prio) {
            traverse_prio = prio_2;
            traverse_id = 2;
        }
    }

    return traverse_id;
}
#endif //PROJECT_PLIC_CORE_H
