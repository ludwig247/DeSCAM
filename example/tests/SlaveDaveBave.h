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

    SC_CTOR(TestBasic28):
            test_in("test_in"),
            test_out("test_out")
    {
        SC_THREAD(fsm);
    }
    void fsm()
    {

        foo = 23;
        bar = 24;
        while(true)
        {
          test_in->read(foo);

          bar = static_cast<unsigned int>(~foo) + bar ;
          if(bar > 10){
              ++bar;
          }
          test_out->write(bar);
        }
    }
};

#endif //PROJECT_SLAVEDAVEBAVE_H_H
