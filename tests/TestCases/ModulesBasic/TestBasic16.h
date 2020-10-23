//
// Created by hesselberg on 9/28/20.
//

#ifndef SCAM_TESTBASIC16_H
#define SCAM_TESTBASIC16_H


#include "systemc.h"
#include "Interfaces.h"
#include "../Types.h"

struct TestBasic16 : public sc_module {
    enum Phases {
        SECTION_A, SECTION_B
    };

    Phases phase;
    Phases nextphase;


    //Constructor
    SC_HAS_PROCESS(TestBasic16);

    TestBasic16(sc_module_name name) :
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
                b_in->read(compoundType);
                ++compoundType.x;
                if (compoundType.mode == WRITE) {
                    nextphase = SECTION_B;
                }
            }
            if (phase == SECTION_B) {
//                b_out->nb_write(compoundType);
                b_out->try_write(compoundType);
                --compoundType.x;
                compoundType.y = false;
                nextphase = SECTION_A;
            }
        }
    }
};

#endif //SCAM_TESTBASIC16_H
