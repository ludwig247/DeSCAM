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

    int foo;
    unsigned int bar;
    bool test;
    unsigned int test_var() const {
        return ADD_HEX;
    }

    SC_CTOR(Test_Nordic) :
            //test_in("test_in"),
            test_out("test_out") {
        SC_THREAD(fsm);
    }

    void fsm() {
        while (true) {
            //insert_state("idle");
            //insert_state("");
            insert_state();
            insert_state("abc");
//            test_out->master_write(0, "test");
//            test_in2->master_read(foo, "foo0");
//            test_in2->master_read(foo, "foo1");
//            test_in2->master_read(foo, "foo2");
//            test_in2->master_read(foo, "foo3");
//            test_in2->master_read(foo, "foo4");
//            test_in2->master_read(foo, "foo5");
            test_in2->master_read(foo, "foo6");
                b_in->read(foo);
                b_in->read(foo,"frag");
                b_in->try_read(foo,test,"yes");
                b_out->write(0);
                b_out->write(1,"please");
                b_out->try_write(foo,test,"name");
        }
    }
};

#endif //PROJECT_SLAVEDAVEBAVE_H_H
