//
// Created by ludwig on 16.01.20.
//

#ifndef DESCAM_MODULESGLOBAL_H
#define DESCAM_MODULESGLOBAL_H

#include "systemc.h"
#include "../../../example/Interfaces/Interfaces.h"

const unsigned number = 0x111;
const unsigned int number2 = 0x111;
const int number3 = 20;
const bool number4 = true;

 SC_MODULE(TestGlobal1)
{
    blocking_in <int> test_in;
    blocking_out<unsigned int> test_out;

    int foo;
    unsigned int bar;

    unsigned int test_var(unsigned int val) const {
        return val+3+number;
    }

    SC_CTOR(TestGlobal1):
            test_in("test_in"),
            test_out("test_out")
    {
        SC_THREAD(fsm);
    }
    void fsm()
    {
        while(true)
        {
          //test_in->read(foo);
          if(number4){

          bar = number + bar;

          bar = bar + number2;

          bar = bar + static_cast<unsigned>(number3);

          bar = bar + test_var(number2);
          }
          test_out->write(bar);

        }
    }
};



unsigned int compute(unsigned int param, int param2) {
    if(param > 10 && param2 > 10){
        return param +1 ;
    }else return param + static_cast<unsigned int>(param2);
}

int compute2(int param, unsigned int param2){
    //param = param + static_cast<int>(param);
    return param+3;
}

bool compute3(bool param, unsigned int val){
    if(param) return val+2;
    else return val;
}

SC_MODULE(TestGlobal2) {
    blocking_in<int> test_in;
    blocking_out<unsigned int> test_out;

    int foo;
    unsigned int bar;
    unsigned int list[5];


    SC_CTOR(TestGlobal2):
            test_in("test_in"),
            test_out("test_out") {
        SC_THREAD(fsm);
    }

    void fsm() {
        while (true) {
            test_in->read(foo);
            bar = bar + static_cast<unsigned int>(compute2(foo,bar));
            bar = bar + compute(3,compute2(foo,bar));
            bar = bar + compute(list[0],5);
            if(compute3(foo>5,bar)){
                test_out->write(bar);
            }else test_out->write(bar+1);

        }
    }
};


#endif //DESCAM_MODULESGLOBAL_H