//
// Created by hesselberg on 9/28/20.
//

#ifndef SCAM_TESTBASIC0_H
#define SCAM_TESTBASIC0_H

#include "systemc.h"
#include "Interfaces.h"
#include "../Types.h"

struct TestBasic00 : public sc_module {
    //Sections
    enum Phases {
        SECTION_A, SECTION_B
    };

    Phases phase;
    Phases nextphase;


    //Constructor
    SC_HAS_PROCESS(TestBasic00);

    TestBasic00(sc_module_name name) :
            b_out("b_out")
    {
        SC_THREAD(fsm);
    }

    //Out-port
    blocking_out<int> b_out;

    void fsm() {
        nextphase = SECTION_A;
        while (true) {
            phase = nextphase;
            if (phase == SECTION_A) {
                b_out->write(5);
                nextphase = SECTION_B;
            }
            if (phase == SECTION_B) {
                nextphase = SECTION_A;
            }
        }
    }
};
#endif //SCAM_TESTBASIC0_H
