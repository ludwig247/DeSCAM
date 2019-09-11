//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 11/22/18.
//

#ifndef PROJECT_CLINT_SOFTWARESTATUS_H
#define PROJECT_CLINT_SOFTWARESTATUS_H

// Adjusts code to be appropriate for the SCAM tool
// Working ESL-Description -> #define NOSCAM
// Properties can be generated -> //#define NOSCAM
//#define NOSCAM

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

    slave_in<unsigned int> fromMemory_sip;

    slave_out<bool> MSIP_port;

    unsigned int msip_data;
    bool rec;

    void run() {
        while (true) {
            fromMemory_sip->nb_read(msip_data);

            if (msip_data > 0) {
                MSIP_port->nb_write(true);
            } else {
                MSIP_port->nb_write(false);
            }
        }
    }
};


#endif //PROJECT_CLINT_SOFTWARESTATUS_H
