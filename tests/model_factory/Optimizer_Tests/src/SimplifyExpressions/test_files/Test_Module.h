//
// Created by mi-alkoudsi 08.12.19
//

#ifndef OPTIMIZER_SIM_TESTING_H
#define OPTIMIZER_SIM_TESTING_H

#include "systemc.h"
#include "../../../../example/Interfaces/Interfaces.h"


struct Test_Module0 : public sc_module {
    int x;
    bool y;
    //Constructor
    SC_HAS_PROCESS(Test_Module0);

    Test_Module0(sc_module_name name) :
            b_out("b_out") {
        SC_THREAD(fsm);
    }

    //ports
    blocking_in<bool> a_in;
    blocking_out<int> a_out;
    blocking_out<int> b_out;
    blocking_out<int> c_out;

    void fsm() {
        while (true) {
            a_in->read(y);
            if (y == false) {
                a_out->write(3 * 5 + 1);
                b_out->write(x + 4 / 2);
                c_out->write(x + 4 % 3);
            } else {
                a_out->write(((2 & 3)) | ((2 << 1) & 5));
                b_out->write((x & 3) << 2);
                c_out->write(x + (2 & 3) | ((2 << 1) & 5));
            }
        }
    }
};

#endif //OPTIMIZER_SIM_TESTING_H


