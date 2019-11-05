//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 11/22/18.
//

#ifndef PROJECT_CLINT_TIMER_H
#define PROJECT_CLINT_TIMER_H

// Adjusts code to be appropriate for the SCAM tool
// Working ESL-Description -> #define NOSCAM
// Properties can be generated -> //#define NOSCAM
//#define NOSCAM

#include "systemc.h"
//#include "Interfaces.h"


class CLINT_Timer : public sc_module {
public:

    //Constructor
    SC_HAS_PROCESS(CLINT_Timer);

    CLINT_Timer(sc_module_name name) :
            toMemory_L("toMemory_L"),
            toMemory_H("toMemory_H"),
            toTimerStatus_L("toTimerStatus_L"),
            toTimerStatus_H("toTimerStatus_H"),
            mtimeL(0),
            mtimeH(0)
    {
        SC_THREAD(run);
    }

    slave_out<unsigned int> toMemory_L;
    slave_out<unsigned int> toMemory_H;
    slave_out<unsigned int> toTimerStatus_L;
    slave_out<unsigned int> toTimerStatus_H;

    unsigned int mtimeL;
    unsigned int mtimeH;

    void run() {
        while (true) {
            toMemory_L->slave_write(mtimeL);
            toMemory_H->slave_write(mtimeH);
            toTimerStatus_L->slave_write(mtimeL);
            toTimerStatus_H->slave_write(mtimeH);

            ++mtimeL;
            if (mtimeL == 0)
                ++mtimeH;

            wait(WAIT_TIME, SC_PS);
//            wait(SC_ZERO_TIME);//FIXME: definitely need it
        }
    }
};


#endif //PROJECT_CLINT_TIMER_H
