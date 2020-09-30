//
// Created by hesselberg on 9/28/20.
//

#ifndef SCAM_TESTBASIC4_H
#define SCAM_TESTBASIC4_H

#include "systemc.h"
#include "Interfaces.h"
#include "../Types.h"

struct TestBasic04 : public sc_module {
    //Constructor
    TestBasic04(sc_module_name name) :
            b_out("b_out"),
            var(4) {
        SC_THREAD(fsm);
    }

    SC_HAS_PROCESS(TestBasic04);

    //Out port
    blocking_out<int> b_out;
    //Variable
    bool nb_result;
    int var;

    void fsm() {
        while (true) {
//            nb_result = b_out->nb_write(var); //state_5
            b_out->try_write(var,nb_result); //state_5
            if (nb_result) {
                ++var;
            } else {
                --var;
            }
            wait(SC_ZERO_TIME); // not considered! should be wait(0) to be valid
        }
    }
};
#endif //SCAM_TESTBASIC4_H
