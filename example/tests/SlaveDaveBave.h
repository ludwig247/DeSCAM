//
// Created by ludwig on 10.10.17.
//

#ifndef PROJECT_SLAVEDAVEBAVE_H_H
#define PROJECT_SLAVEDAVEBAVE_H_H


#include "systemc.h"
#include "../Interfaces/Interfaces.h"

SC_MODULE(TestBasic28)
{
    blocking_in <int> test_in;
    blocking_out<unsigned int> test_out;

    int foo;
    unsigned int bar;

    unsigned int test() const {
        return 0x395;
    }

    SC_CTOR(TestBasic28):
            test_in("test_in"),
            test_out("test_out")
    {
        SC_THREAD(fsm);
    }
    void fsm()
    {
        while(true)
        {
          test_in->read(foo);

          bar = bar + test();
          test_out->write(bar);
        }
    }
};

#endif //PROJECT_SLAVEDAVEBAVE_H_H
