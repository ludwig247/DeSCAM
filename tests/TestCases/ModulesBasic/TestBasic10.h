//
// Created by hesselberg on 9/28/20.
//

#ifndef SCAM_TESTBASIC10_H
#define SCAM_TESTBASIC10_H

#include "systemc.h"
#include "Interfaces.h"
#include "../Types.h"

struct TestBasic10 : public sc_module {
    //Sections
    enum Phases {
        SECTION_A, SECTION_B
    };

    Phases phase;
    Phases nextphase;


    //Constructor
    SC_HAS_PROCESS(TestBasic10);

    TestBasic10(sc_module_name name) :
            b_out("b_out"),
            b_in("b_in") {
        SC_THREAD(fsm);
    }

    //Out-port
    blocking_out<CompoundType> b_out;
    blocking_in<CompoundType> b_in;

    //Vars
    CompoundType compoundType;

    void fsm() {
        nextphase = SECTION_A;
        while (true) {
            phase = nextphase;
            if (phase == SECTION_A) {
                b_in->read(compoundType);//state_11
                b_out->write(compoundType);//state_12
                nextphase = SECTION_B;
            }
            if (phase == SECTION_B) {
                nextphase = SECTION_A;
            }
        }
    }
};

#endif //SCAM_TESTBASIC10_H
