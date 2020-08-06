//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 11/22/18.
//

#ifndef PROJECT_CLINT_TIMERSTATUS_H
#define PROJECT_CLINT_TIMERSTATUS_H

// Adjusts code to be appropriate for the SCAM tool
// Working ESL-Description -> #define NOSCAM
// Properties can be generated -> //#define NOSCAM
//#define NOSCAM

#include "systemc.h"
#include "Interfaces.h"


class CLINT_TimerStatus : public sc_module {
public:

    //Constructor
    SC_HAS_PROCESS(CLINT_TimerStatus);

    CLINT_TimerStatus(sc_module_name name) :
            fromTimer_L("fromTimer_L"),
            fromTimer_H("fromTimer_H"),
            fromMemory_timecmp_L("fromMemory_timecmp_L"),
            fromMemory_timecmp_H("fromMemory_timecmp_H"),
            MTIP_port("MTIP_port"),
            mtimeL_data(0),
            mtimeH_data(0),
            mtimecmpL_data(0x7FFFFFFF),
            mtimecmpH_data(0x7FFFFFFF) {
        SC_THREAD(run);
    }

    master_in<unsigned int> fromTimer_L;
    master_in<unsigned int> fromTimer_H;
    slave_in<unsigned int> fromMemory_timecmp_L;
    slave_in<unsigned int> fromMemory_timecmp_H;

    slave_out<bool> MTIP_port;

    unsigned int mtimeL_data;
    unsigned int mtimeH_data;
    unsigned int mtimecmpL_data;
    unsigned int mtimecmpH_data;

    void run() {
        while (true) {
            fromTimer_L->read(mtimeL_data);
            fromTimer_H->read(mtimeH_data);

            fromMemory_timecmp_L->nb_read(mtimecmpL_data);
            fromMemory_timecmp_H->nb_read(mtimecmpH_data);

            if ((mtimeL_data >= mtimecmpL_data) && (mtimeH_data >= mtimecmpH_data)) {
                MTIP_port->nb_write(true);
            } else {
                MTIP_port->nb_write(false);
            }
        }
    }
};


#endif //PROJECT_CLINT_TIMERSTATUS_H
