//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 11/22/18.
//

#ifndef PROJECT_CLINT_TIMER_H
#define PROJECT_CLINT_TIMER_H

#include "systemc.h"
#include "Interfaces.h"


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

    shared_out<unsigned int> toMemory_L;
    shared_out<unsigned int> toMemory_H;
    shared_out<unsigned int> toTimerStatus_L;
    shared_out<unsigned int> toTimerStatus_H;

    unsigned int mtimeL;
    unsigned int mtimeH;

    void run() {
        while (true) {
            toMemory_L->set(mtimeL);
            toMemory_H->set(mtimeH);
            toTimerStatus_L->set(mtimeL);
            toTimerStatus_H->set(mtimeH);

            ++mtimeL;
            if (mtimeL == 0)
                ++mtimeH;

            wait(SC_ZERO_TIME);
        }
    }
};


#endif //PROJECT_CLINT_TIMER_H
