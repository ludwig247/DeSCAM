//
// Created by mi-alkoudsi 09.12.19
//

#ifndef OPTIMIZER_FO_TESTING_H
#define OPTIMIZER_FO_TESTING_H

#include "systemc.h"
#include "../../../../example/Interfaces/Interfaces.h"

#define num 8

int add(int arg1, int arg2) {
    return arg1 + arg2;
}

int sub(int arg1, int arg2) {
    return arg1 - arg2;
}

int mul(int arg1, int arg2) {
    return arg1 * arg2;
}

int divi(int arg1, int arg2) {
    return arg1 / arg2;
}

int mod(int arg1, int arg2) {
    return arg1 % arg2;
}


struct Test_Module_GlobalFunctions0 : public sc_module {
    int x, y;
    //Constructor
    SC_HAS_PROCESS(Test_Module_GlobalFunctions0);

    Test_Module_GlobalFunctions0(sc_module_name
                                 name) :
            b_out("b_out") {
        SC_THREAD(fsm);
    }

    //ports
    blocking_in<int> b_in;
    blocking_out<int> b_out;

    void fsm() {
        while (true) {
            b_in->read(y);
            if (y == 0x1) {
                b_out->write(add(20, 10));
            } else if (y == 0x2) {
                b_out->write(add(x, 10));
            } else if (y == 0x3) {
                b_out->write(sub(20, 10));
            } else if (y == 0x4) {
                b_out->write(mul(x, 15));
            } else if (y == 0x5) {
                b_out->write(mul(17, x));
            } else if (y == 0x6) {
                b_out->write(divi(x, 4));
            } else if (y == 0x7) {
                b_out->write(mod(x, num));
            } else {}
        }
    }
};

#endif //OPTIMIZER_FO_TESTING_H


