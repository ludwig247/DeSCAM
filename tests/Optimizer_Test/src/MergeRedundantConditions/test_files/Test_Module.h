//
// Created by mi-alkoudsi 10.12.19
//

#ifndef OPTIMIZER_MRC_TESTING_H
#define OPTIMIZER_MRC_TESTING_H

#include "systemc.h"
#include "../../../../example/Interfaces/Interfaces.h"

struct Test_Module0 : public sc_module {

    int x, y;

    //Constructor
    SC_HAS_PROCESS(Test_Module0);

    Test_Module0(sc_module_name name) :
           b_in("b_in"), b_out("b_out") {
        SC_THREAD(fsm);
    }

    //ports
    blocking_in<int> b_in;
    blocking_out<int> b_out;

    void fsm() {
        while (true) {
            b_in->read(y);
            if (y == 0) {
                b_out->write(x);
            } else {
                b_out->write(x);
            }
        }
    }
};

struct Test_Module1 : public sc_module {

    int x, y;

    //Constructor
    SC_HAS_PROCESS(Test_Module1);

    Test_Module1(sc_module_name name) :
            b_in("b_in"), b_out("b_out") {
        SC_THREAD(fsm);
    }

    //ports
    blocking_in<int> b_in;
    blocking_out<int> b_out;

    void fsm() {
        while (true) {
            b_in->read(y);
            if (y == 0) {
                b_out->write(x);
            } else if (y == 1) {
                b_out->write(x);
            } else if (y == 2) {
                b_out->write(-x);
            } else {
                b_out->write(-x);
            }
        }
    }
};

struct Test_Module2 : public sc_module {

    int x, y;

    //Constructor
    SC_HAS_PROCESS(Test_Module2);

    Test_Module2(sc_module_name
    name):  b_in("b_in"), b_out("b_out") {
        SC_THREAD(fsm);
    }

    //ports
    blocking_in<int> b_in;
    blocking_out<int> b_out;

    void fsm() {
        while (true) {
            b_in->read(y);
            if (y == 0) {
                b_out->write(x);
            } else if (y == 1) {
                if (y > 0) {
                    b_out->write(x);
                } else {
                    b_out->write(x);
                }
            } else {
                b_out->write(-x);
            }
        }
    }
};

#endif //OPTIMIZER_MRC_TESTING_H


