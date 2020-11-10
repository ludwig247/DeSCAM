//
// Created by mi-alkoudsi 09.12.19
//

#ifndef OPTIMIZER_FUF_TESTING_H
#define OPTIMIZER_FUF_TESTING_H

#include "systemc.h"
#include "../../../../example/Interfaces/Interfaces.h"


struct Test_Module : public sc_module {
    //Sections
    enum Phases {
        SECTION_A, SECTION_B
    };

    Phases phase;
    Phases nextphase;
    int x;
    bool y;
    int increment(int x) const{ return x + 1;}
    unsigned decrement(unsigned x) const{ return x - 1;}
    bool bigger(int x, int y) const{ return x > y;}

    //Constructor
    SC_HAS_PROCESS(Test_Module);

    Test_Module(sc_module_name name) :
            b_out("b_out")
            {
        SC_THREAD(fsm);
    }

    //ports
    blocking_in<int> b_in;
    blocking_out<int> b_out;

    void fsm() {
        nextphase = SECTION_A;
        while (true) {
                b_in->read(x);
       		if(bigger(x,0)){
		b_out->write(x);
		}else{
		b_out->write(-x);
		}
            }
    }
};
#endif //OPTIMIZER_FUF_TESTING_H


