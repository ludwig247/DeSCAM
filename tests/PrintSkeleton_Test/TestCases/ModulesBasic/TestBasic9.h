//
// Created by hesselberg on 9/28/20.
//

#ifndef SCAM_TESTBASIC9_H
#define SCAM_TESTBASIC9_H

#include "systemc.h"
#include "Interfaces.h"
#include "../Types.h"

struct TestBasic9 : public sc_module {
    //Constructor
    TestBasic9(sc_module_name name) :
    //sensor_in("sensor_in"),
            b_in("b_in"),
            m_in("m_in"),
            var(1337) {
        SC_THREAD(fsm);
    }

    SC_HAS_PROCESS(TestBasic9);

    //Out port
    blocking_in<int> b_in;
    master_in<int> m_in;
    //Variable - both should be removed from the model
    bool nb_result;
    int var;

    void fsm() {
        while (true) {
            b_in->read(var);
            m_in->master_read(var);
            wait(SC_ZERO_TIME);
        }
    }
};
#endif //SCAM_TESTBASIC9_H
