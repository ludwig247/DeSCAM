//
// Created by hesselberg on 9/30/20.
//

#ifndef SCAM_TESTGLOBAL2_H
#define SCAM_TESTGLOBAL2_H

#include "systemc.h"
#include "Interfaces.h"
#include "../Types.h"

unsigned int compute(unsigned int param, int param2) {
    if (param > 10 && param2 > 10) {
        return param + 1;
    } else return param + static_cast<unsigned int>(param2);
}

int nested(unsigned int param2) {
    return static_cast<int>(param2) + 3;
}

int compute2(int param, unsigned int param2) {
    param = param + static_cast<int>(param2);
    return param + 3 + nested(param2);
}

bool compute3(bool param, unsigned int val) {
    if (param) return val + 2;
    else return val;
}


bool global_intern(bool param, unsigned int val) {
    if (param) return val + intern;
    else return val;
}

SC_MODULE(TestGlobal2) {
        blocking_in<int> test_in;
        blocking_out<unsigned int> test_out;

        int foo;
        unsigned int bar;
        unsigned int list[5];

        SC_CTOR(TestGlobal2) :
        test_in("test_in"),
        test_out("test_out") {
            SC_THREAD(fsm);
        }

        void fsm() {
            while (true) {
                test_in->read(foo);
                bar = bar + static_cast<unsigned int>(compute2(foo, bar));
                bar = bar + compute(3, compute2(foo, bar));
                bar = bar + compute(list[0], 5);
                if (compute3(foo > 5, bar)) {
                    test_out->write(bar);
                } else test_out->write(bar + 1);
            }
        }
};

#endif //SCAM_TESTGLOBAL2_H
