//
// Created by hesselberg on 9/28/20.
//

#ifndef SCAM_TESTFUNCTION0_H
#define SCAM_TESTFUNCTION0_H

#include "systemc.h"
#include "Interfaces.h"
#include "../Types.h"



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

#endif //SCAM_TESTFUNCTION0_H
