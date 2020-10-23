//
// Created by hesselberg on 9/28/20.
//

#ifndef SCAM_TESTBASIC1_H
#define SCAM_TESTBASIC1_H

#include "systemc.h"
#include "Interfaces.h"
#include "../Types.h"

struct TestBasic01 : public sc_module {
    //Sections
    enum Phases {
        SECTION_A, SECTION_B
    };

    Phases phase;
    Phases nextphase;


    //Constructor
    SC_HAS_PROCESS(TestBasic01);

    TestBasic01(sc_module_name name) :
            b_in("b_in") {
        SC_THREAD(fsm);
    }

    //Out-port
    blocking_in<int> b_in;
    //Vars
    int x;

    void fsm() {
        nextphase = SECTION_A;
        while (true) {
            phase = nextphase;
            if (phase == SECTION_A) {
                b_in->read(x);
                nextphase = SECTION_B;
            }
            if (phase == SECTION_B) {
                nextphase = SECTION_A;
            }
        }
    }
};

#endif //SCAM_TESTBASIC1_H
