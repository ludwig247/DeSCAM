//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 11/22/18.
//

#ifndef PROJECT_CLINT_SOFTWARESTATUS_H
#define PROJECT_CLINT_SOFTWARESTATUS_H

#include "systemc.h"
#include "Interfaces.h"


class CLINT_SipStatus : public sc_module {
public:

    //Constructor
    SC_HAS_PROCESS(CLINT_SipStatus);

    CLINT_SipStatus(sc_module_name name) :
            fromMemory_sip("fromMemory_sip"),
            MSIP_port("MSIP_port"),
            msip_data(0),
            rec(false) {
        SC_THREAD(run);
    }

    shared_in<unsigned int> fromMemory_sip;

    slave_out<bool> MSIP_port;

    unsigned int msip_data;
    bool rec;

    void run() {
        while (true) {
            if (msip_data > 0) {
                MSIP_port->nb_write(true);
            } else {
                MSIP_port->nb_write(false);
            }

            fromMemory_sip->get(msip_data);
        }
    }
};


#endif //PROJECT_CLINT_SOFTWARESTATUS_H
