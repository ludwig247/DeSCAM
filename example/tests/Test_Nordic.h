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
const int number3 = 20;
//TODO: allow negativ numbers for integer ..
const bool number4 = true;

unsigned int compute(unsigned int param, int param2) {
    if(param > 10 && param2 > 10){
        return param +1 ;
    }else return param + static_cast<unsigned int>(param2);
}

int compute2(int param, unsigned int param2){
    //param = param + static_cast<int>(param);
    return param+3;
}

SC_MODULE(ModuleGlobalVars) {
    blocking_in<int> test_in;
    blocking_out<unsigned int> test_out;

    int foo;
    unsigned int bar;
    unsigned int list[5];


    SC_CTOR(ModuleGlobalVars):
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

            test_out->write(bar);

        }
    }
};
//};SC_MODULE(ModuleGlobalVars)
//{
//    blocking_in <int> test_in;
//    blocking_out<unsigned int> test_out;
//
//    int foo;
//    unsigned int bar;
//
//    unsigned int test_var(unsigned int val) const {
//        return val+3+number;
//    }
//
//    SC_CTOR(ModuleGlobalVars):
//            test_in("test_in"),
//            test_out("test_out")
//    {
//        SC_THREAD(fsm);
//    }
//    void fsm()
//    {
//        while(true)
//        {
//          //test_in->read(foo);
//
//          if(number4){
//
//          bar = number + bar;
//
//          bar = bar + number2;
//
//          bar = bar + static_cast<unsigned>(number3);
//
//          bar = bar + test_var(number2);
//          }
//          test_out->write(bar);
//
//        }
//    }
//};

#endif //PROJECT_SLAVEDAVEBAVE_H_H
