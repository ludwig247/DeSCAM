//
// Created by hesselberg on 9/28/20.
//

#ifndef SCAM_GLOBALLOCAL_H
#define SCAM_GLOBALLOCAL_H

#include "systemc.h"
#include "Interfaces.h"
#include "../Types.h"


SC_MODULE(TestGlobal1) {
    blocking_in<int> test_in;
    blocking_out<unsigned int> test_out;

    int foo;
    unsigned int bar;

    unsigned int test_var(unsigned int val) const {
        return val + 3 + number;
    }

    SC_CTOR(TestGlobal1) :
            test_in("test_in"),
            test_out("test_out") {
        SC_THREAD(fsm);
    }

    void fsm() {
        while (true) {
            //test_in->read(foo);
            if (number4) {

                bar = number + bar;

                bar = bar + number2;

                bar = bar + static_cast<unsigned>(number3);

                bar = bar + test_var(number2);
            }
            test_out->write(bar);

        }
    }
};
#endif //SCAM_GLOBALLOCAL_H
