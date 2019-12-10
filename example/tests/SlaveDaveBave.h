//
// Created by ludwig on 10.10.17.
//

#ifndef PROJECT_SLAVEDAVEBAVE_H_H
#define PROJECT_SLAVEDAVEBAVE_H_H


#include "systemc.h"
#include "../Interfaces/Interfaces.h"

#define ADD_HEX 0x100


SC_MODULE(Test_Nordic) {
    blocking_in<int> test_in;
    master_out<unsigned int> test_out;

    int foo;
    unsigned int bar;

    unsigned int test_var() const {
        return ADD_HEX;
    }

    SC_CTOR(Test_Nordic) :
            test_in("test_in"),
            test_out("test_out") {
        SC_THREAD(fsm);
    }

    void fsm() {
        while (true) {
            test_in->read(foo);
            //bar = bar + test_var();
            test_out->master_write(bar);
            test_out->master_write(bar+2, "test");
        }
    }
};

#endif //PROJECT_SLAVEDAVEBAVE_H_H
