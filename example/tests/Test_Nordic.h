//
// Created by ludwig on 10.10.17.
//

#ifndef PROJECT_SLAVEDAVEBAVE_H_H
#define PROJECT_SLAVEDAVEBAVE_H_H


#include "systemc.h"
#include "../Interfaces/Interfaces.h"
#define ADD_HEX 0x100

const unsigned number = 0x111;
const unsigned int number2 = 0x111;
const int number3 = ADD_HEX;
const bool number4 = true;

SC_MODULE(Test_Nordic)
{
    blocking_in <int> test_in;
    blocking_out<unsigned int> test_out;

    int foo;
    unsigned int bar;

    unsigned int test_var() const {
        return ADD_HEX;
    }

    SC_CTOR(Test_Nordic):
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
          if(number4){
              bar = bar + number2;
          }

          bar = bar + test_var() + static_cast<unsigned int>(foo) + static_cast<unsigned int>(number3);

          bar = number + bar;
          test_out->write(bar);
        }
    }
};

#endif //PROJECT_SLAVEDAVEBAVE_H_H
