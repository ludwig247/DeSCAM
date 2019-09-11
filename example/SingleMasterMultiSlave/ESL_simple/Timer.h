//
// Created by ludwig on 18.01.17.
//

#ifndef PROJECT_TIMER_H
#define PROJECT_TIMER_H

#include "systemc.h"
#include "../../Interfaces/Interfaces.h"
#include "Compound.h"

struct Timer : public sc_module {
public:
    //Out-port
    blocking_out<bool> timer_dt;

    //Constructor
    SC_HAS_PROCESS(Timer);
    Timer(sc_module_name name)
        {
        SC_THREAD(fsm);
    };

    void fsm() {
        int cnt;
        while (true) {
            cnt = std::rand()%10;
            if(cnt == 1){
                timer_dt->write(true);
            }
        }
    }
};







#endif //PROJECT_TIMER_H
