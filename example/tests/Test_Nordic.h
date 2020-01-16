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

SC_MODULE(TestGlobal2) {
    blocking_in<int> test_in;
    blocking_out<unsigned int> test_out;

    int foo;
    unsigned int bar;
    unsigned int list[5];
    bool test;

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

            if(compute3(true,bar)){
                test_out->write(bar);
            }else test_out->write(bar+1);

        }
    }
};
//};
//
//


#endif //PROJECT_SLAVEDAVEBAVE_H_H
