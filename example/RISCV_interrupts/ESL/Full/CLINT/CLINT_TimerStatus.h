//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 11/22/18.
//

#ifndef PROJECT_CLINT_TIMERSTATUS_H
#define PROJECT_CLINT_TIMERSTATUS_H

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

    shared_in<unsigned int> fromTimer_L;
    shared_in<unsigned int> fromTimer_H;
    shared_in<unsigned int> fromMemory_timecmp_L;
    shared_in<unsigned int> fromMemory_timecmp_H;

    slave_out<bool> MTIP_port;

    unsigned int mtimeL_data;
    unsigned int mtimeH_data;
    unsigned int mtimecmpL_data;
    unsigned int mtimecmpH_data;

    void run() {
        while (true) {
            if ((mtimeL_data >= mtimecmpL_data) && (mtimeH_data >= mtimecmpH_data)) {
                MTIP_port->nb_write(true);
            } else {
                MTIP_port->nb_write(false);
            }

            fromTimer_L->get(mtimeL_data);
            fromTimer_H->get(mtimeH_data);

            fromMemory_timecmp_L->get(mtimecmpL_data);
            fromMemory_timecmp_H->get(mtimecmpH_data);
        }
    }
};


#endif //PROJECT_CLINT_TIMERSTATUS_H
