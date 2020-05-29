//
// Created by ludwig on 10.10.17.
//

#ifndef PROJECT_SLAVEDAVEBAVE_H_H
#define PROJECT_SLAVEDAVEBAVE_H_H


#include "systemc.h"
#include "../Interfaces/Interfaces.h"

#define ADD_HEX 0x100


SC_MODULE(Test_Nordic) {
    blocking_in<int> b_in;
    blocking_out<int> b_out;
    master_in<int> test_in2;
    master_out<unsigned int> test_out;

    unsigned int bar;
    int foo;
    int arr[10];
    bool test;

    unsigned int update_suspending_count(bool active, unsigned int suspending_count) const {
        if (active) {
            return 0;
        } else {
            return suspending_count + 1;
        }
    }

    SC_CTOR(Test_Nordic) :
    //test_in("test_in"),
            test_out("test_out") {
        SC_THREAD(fsm);
    }

    void fsm() {
        while (true) {
            b_in->read(foo);
            arr[foo] = foo + 3;
            if(update_suspending_count(test,bar) != 0 ){
                test_out->master_write(0);
            }else{
                test_out->master_write(1);
            }
        }
        }
    };

#endif //PROJECT_SLAVEDAVEBAVE_H_H
