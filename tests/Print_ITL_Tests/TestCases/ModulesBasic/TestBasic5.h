//
// Created by hesselberg on 9/28/20.
//

#ifndef SCAM_TESTBASIC5_H
#define SCAM_TESTBASIC5_H

#include "systemc.h"
#include "Interfaces.h"
#include "../Types.h"

struct TestBasic5 : public sc_module {
    //Constructor
    TestBasic5(sc_module_name name) :
    //sensor_in("sensor_in"),
            b_out("b_out"),
            b_in("b_in"),
            var(4) {
        SC_THREAD(fsm);
    }

    SC_HAS_PROCESS(TestBasic5);

    //Out port
    blocking_out<int> b_out;
    blocking_in<int> b_in;
    //Variable - both should be removed from the model
    bool nb_result;
    int var;

    void fsm() {
        while (true) {
            b_in->read(var);
            b_out->write(var);
            wait(SC_ZERO_TIME);
        }
    }
};
#endif //SCAM_TESTBASIC5_H
