//
// Created by hesselberg on 9/28/20.
//

#ifndef SCAM_TESTBASIC3_H
#define SCAM_TESTBASIC3_H

#include "systemc.h"
#include "Interfaces.h"
#include "../Types.h"

struct TestBasic03 : public sc_module {

    //Constructor
    TestBasic03(sc_module_name name) :
            b_out("b_out") {
        SC_THREAD(fsm);
    }

    SC_HAS_PROCESS(TestBasic03);

    //Out port
    blocking_out<int> b_out;
    //Variable
    bool nb_result;

    void fsm() {
        while (true) {
//            nb_result = b_out->nb_write(10); //state_4
            b_out->try_write(10,nb_result); //state_4
            if (nb_result) {
//                b_out->nb_write(11); //state_6
                b_out->try_write(11); //state_6
            }
            wait(SC_ZERO_TIME); // not considered! should be wait(0) to be valid
        }
    }
};
#endif //SCAM_TESTBASIC3_H
