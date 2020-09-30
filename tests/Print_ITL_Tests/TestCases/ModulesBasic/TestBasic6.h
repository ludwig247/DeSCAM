//
// Created by hesselberg on 9/28/20.
//

#ifndef SCAM_TESTBASIC6_H
#define SCAM_TESTBASIC6_H

#include "systemc.h"
#include "Interfaces.h"
#include "../Types.h"

struct TestBasic06 : public sc_module {
    //Constructor
    TestBasic06(sc_module_name name) :
            b_in("b_in"),
            b_in2("b_in2"),
            var(4) {
        SC_THREAD(fsm);
    }

    SC_HAS_PROCESS(TestBasic06);

    //Out port
    blocking_in<int> b_in;
    blocking_in<int> b_in2;
    //Variable - both should be removed from the model
    bool nb_result;
    int var;

    void fsm() {
        while (true) {
            b_in->read(var); //state_5
            b_in2->read(var); //state_6
            wait(SC_ZERO_TIME); //No state
        }
    }
};
#endif //SCAM_TESTBASIC6_H
