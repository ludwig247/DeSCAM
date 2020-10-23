//
// Created by hesselberg on 9/28/20.
//

#ifndef SCAM_TESTBAISC11_H
#define SCAM_TESTBAISC11_H

#include "systemc.h"
#include "Interfaces.h"
#include "../Types.h"

struct TestBasic11 : public sc_module {
    //Sections
    enum Phases {
        SECTION_A, SECTION_B
    };

    Phases phase;
    Phases nextphase;


    //Constructor
    SC_HAS_PROCESS(TestBasic11);

    TestBasic11(sc_module_name name) :
            b_out("b_out") {
        SC_THREAD(fsm);
    }

    //Out-port
    blocking_out<CompoundType> b_out;

    //Vars
    CompoundType compoundType;

    void fsm() {
        nextphase = SECTION_A;
        while (true) {
            phase = nextphase;
            if (phase == SECTION_A) {
                b_out->write(compoundType);
                if (compoundType.x > 10)
                    nextphase = SECTION_B;
            }
            if (phase == SECTION_B) {
                compoundType.mode = WRITE;
                compoundType.y = false;
                --compoundType.x;
                nextphase = SECTION_A;
            }
        }
    }
};
#endif //SCAM_TESTBAISC11_H
