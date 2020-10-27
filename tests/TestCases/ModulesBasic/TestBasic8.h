//
// Created by hesselberg on 9/28/20.
//

#ifndef SCAM_TESTBASIC8_H
#define SCAM_TESTBASIC8_H

#include "systemc.h"
#include "Interfaces.h"
#include "../Types.h"

struct TestBasic08 : public sc_module {
    //Constructor
    TestBasic08(sc_module_name name) :
            b_in("b_in"),
            m_out("m_out"),
            var(1337) {
        SC_THREAD(fsm);
    }

    SC_HAS_PROCESS(TestBasic08);

    //Out port
    blocking_in<int> b_in;
    master_out<int> m_out;
    //Variable - both should be removed from the model
    bool nb_result;
    int var;

    void fsm() {
        while (true) {
            b_in->read(var); //state_5
            var = 10;
            m_out->master_write(var);
        }
    }
};
#endif //SCAM_TESTBASIC8_H