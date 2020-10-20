//
// Created by hesselberg on 9/28/20.
//

#ifndef SCAM_TESTBASIC3_H
#define SCAM_TESTBASIC3_H

#include "systemc.h"
#include "Interfaces.h"
#include "../Types.h"

struct TestBasic3 : public sc_module {

    //Constructor
    TestBasic3(sc_module_name name) :
            b_out("b_out") {
        SC_THREAD(fsm);
    }

    SC_HAS_PROCESS(TestBasic3);

    //Out port
    blocking_out<int> b_out;
    //Variable
    bool nb_result;

    void fsm() {
        while (true) {
            b_out->try_write(10,nb_result);
            if (nb_result) {
                b_out->try_write(11);
            }
            wait(0);
        }
    }
};
#endif //SCAM_TESTBASIC3_H
