//
// Created by hesselberg on 9/28/20.
//

#ifndef SCAM_TESTBASIC5_H
#define SCAM_TESTBASIC5_H

#include "systemc.h"
#include "Interfaces.h"
#include "../Types.h"

struct TestBasic05 : public sc_module {
    //Constructor
    TestBasic05(sc_module_name name) :
            b_out("b_out"),
            b_in("b_in"),
            var(4) {
        SC_THREAD(fsm);
    }

    SC_HAS_PROCESS(TestBasic05);

    //Out port
    blocking_out<int> b_out;
    blocking_in<int> b_in;
    //Variable - both should be removed from the model // wrong
    bool nb_result;
    int var;

    void fsm() {
        while (true) {
            b_in->read(var); //state_5
            b_out->write(var); //state_6 // need var for case of !sync
            wait(0); //No state
        }
    }
};
#endif //SCAM_TESTBASIC5_H
