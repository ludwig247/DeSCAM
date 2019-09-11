//
// Created by ludwig on 30.07.18.
//

#ifndef PROJECT_MODULEFUNCTIONS_H
#define PROJECT_MODULEFUNCTIONS_H

#include "systemc.h"
#include "Interfaces.h"

struct TestFunction0: public sc_module {

    int foo(int x) const{
        ++x;
        if(x>5) return x<<1;
        if(x>20) return x+2;
        else if(x == 20) return x;
        else return 0;
    }


    //Constructor
    SC_HAS_PROCESS(TestFunction0);
    TestFunction0(sc_module_name name) :
            b_out("b_out"),
            b_in("b_in") {
        SC_THREAD(fsm);
    }

    //Out-port
    blocking_out<unsigned int> b_out;
    blocking_in<int> b_in;

    int x;
    unsigned int y;

    void fsm() {
        while (true) {
                b_in->read(x);
                y = static_cast<unsigned int>(foo(x));
                if(15 > static_cast<unsigned int>(foo(x))){
                    y = 0;
                }
                if(static_cast<unsigned int>(foo(x)) > 0 ){
                    y = 1;
                }
                if(static_cast<unsigned int>(x) > y || y > static_cast<unsigned int>(x)){
                    y = 2;
                }
                b_out->write(y);
        }
    }
};

struct record{int x; unsigned int y;};

SC_MODULE(TestFunction1) {

    unsigned int foo(unsigned int x) const{
        ++x;
        if(x>5) return x<<1;
        if(x>20) return x+2;
        else if(x == 20) return x;
        else return 0;
    }

    //Constructor
    SC_CTOR(TestFunction1):
            b_out("b_out"),
            b_in("b_in") {
        SC_THREAD(fsm);
    }

    //Out-port
    blocking_out<unsigned int> b_out;
    blocking_in<record> b_in;

    int x;
    unsigned int y;
    record record_var;

    void fsm() {
        while (true) {
                b_in->read(record_var);
                y = static_cast<unsigned int>(record_var.x);
                b_out->write(y);
                y = static_cast<unsigned int>(static_cast<int>(record_var.y) + x );
                b_out->write(y);
                y = static_cast<unsigned int>(static_cast<int>(record_var.y) >> static_cast<int>((y) & 0x0000001F));
                b_out->write(y);
                y = static_cast<unsigned int>(static_cast<int>(record_var.y) >> static_cast<int>((foo(record_var.y)) & 0x0000001F));
                b_out->write(y);
        }
    }
};

SC_MODULE(TestFunction2) {

    unsigned int foo(record record_var) const{
        if(static_cast<int>(record_var.y) < 20){
            return static_cast<unsigned int>(static_cast<int>(record_var.y) >> static_cast<int>(y & 0x0000001F));
        }else return 0;
    }

    //Constructor
    SC_CTOR(TestFunction2):
            b_out("b_out"),
            b_in("b_in") {
        SC_THREAD(fsm);
    }

    //Out-port
    blocking_out<unsigned int> b_out;
    blocking_in<record> b_in;

    int x;
    unsigned int y;
    record record_var;

    void fsm() {
        while (true) {
                b_in->read(record_var);

                b_out->write(foo(record_var));
        }
    }
};


#endif //PROJECT_MODULEFUNCTIONS_H
