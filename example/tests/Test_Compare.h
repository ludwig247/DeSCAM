//
// Created by ludwig on 10.10.17.
//

#ifndef PROJECT_SLAVEDAVEBAVE_H_H
#define PROJECT_SLAVEDAVEBAVE_H_H


#include "systemc.h"
#include "../Interfaces/Interfaces.h"
#define ADD_HEX 0x100


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

    if( (val > 0) && !param) return false;
    else return true;
}


struct complex{int x; int y;};

SC_MODULE(TestGlobal2) {
    blocking_in<unsigned int> test_in;
    blocking_out<int> test_out;
    shared_out<bool> test_out_bool;

    unsigned int foo;
    int bar;
//    unsigned int list[5];
    bool test;

    SC_CTOR(TestGlobal2):
            test_in("test_in"),
            test_out("test_out") {
        SC_THREAD(fsm);
    }

    //complex type;
    void fsm() {
        while (true) {
            test_in->try_read(foo,test);
            test = true;
            //test = (foo & 5) == 0;
            bar = (test) ? static_cast<int>(foo+1) : static_cast<int>(foo+0);
            if(test){
                bar = bar +1;
            }
            test_out_bool->set(test);
            test_out->write(bar);
//            type.x = type.x + 5;
//            type.y = type.x + 10;
        }
    }
};
//};
//
//


#endif //PROJECT_SLAVEDAVEBAVE_H_H
