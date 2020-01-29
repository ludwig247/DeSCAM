//
// Created by mi-alkoudsi 08.12.19
//

#ifndef OPTIMIZER_GVP_TESTING_H
#define OPTIMIZER_GVP_TESTING_H

#include "systemc.h"
#include "../../../../example/Interfaces/Interfaces.h"

const int glob1 = 10;
const int glob2 = 0x23;
const unsigned glob4 = 0x20U;
struct Test_Module0 : public sc_module {
    //Sections
    enum Phases {
        SECTION_A, SECTION_B
    };

    Phases phase;
    Phases nextphase;
    int x;
    bool y;

    //Constructor
    SC_HAS_PROCESS(Test_Module0);

    Test_Module0(sc_module_name name) :
            b_out("b_out")
            {
        SC_THREAD(fsm);
    }

    //ports
    blocking_in<bool> b_in;
    blocking_out<int> b_out;

    void fsm() {
        nextphase = SECTION_A;
        x = 5 + glob1;
        while (true) {
            phase = nextphase;
            if (phase == SECTION_A) {  
                b_in->read(y);
                if(y){
                    b_out->write(x + glob2);
                }else{
                    b_out->write(-x - glob2);
                }
                nextphase = SECTION_B;
            }
            if (phase == SECTION_B) {
                nextphase = SECTION_A;
            }
        }
    }
};

struct Test_Module1 : public sc_module {
    //Sections
    enum Phases {
        SECTION_A, SECTION_B
    };

    Phases phase;
    Phases nextphase;
    unsigned x;
    bool y;

    //Constructor
    SC_HAS_PROCESS(Test_Module1);

    Test_Module1(sc_module_name name) :
    b_out("b_out")
    {
        SC_THREAD(fsm);
    }

    //ports
    blocking_in<bool> b_in;
    blocking_out<unsigned> b_out;

    void fsm() {
        nextphase = SECTION_A;
        x = 5;
        while (true) {
            phase = nextphase;
            if (phase == SECTION_A) {
                b_in->read(y);
                if(y){
                    b_out->write(x + glob4);
                }else{
                    b_out->write(x - glob4);
                }
                nextphase = SECTION_B;
            }
            if (phase == SECTION_B) {
                nextphase = SECTION_A;
            }
        }
    }
};
#endif //OPTIMIZER_GVP_TESTING_H


