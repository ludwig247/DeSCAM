//
// Created by hesselberg on 9/28/20.
//

#ifndef SCAM_TESTBASIC12_H
#define SCAM_TESTBASIC12_H

#include "systemc.h"
#include "Interfaces.h"
#include "../Types.h"

struct TestBasic12 : public sc_module {
    //Sections
    enum Phases {
        SECTION_A, SECTION_B
    };

    Phases phase;
    Phases nextphase;


    //Constructor
    SC_HAS_PROCESS(TestBasic12);

    TestBasic12(sc_module_name name) :
            m_out("m_out"),
            b_in("b_in") {
        SC_THREAD(fsm);
    }

    //Out-port
    master_out<int> m_out;
    blocking_in<CompoundType> b_in;

    //Vars
    CompoundType compoundType;

    void fsm() {
        nextphase = SECTION_A;
        while (true) {
            phase = nextphase;
            if (phase == SECTION_A) {
                b_in->read(compoundType);
                if (compoundType.x >= 5) {
                    m_out->master_write(compoundType.x);
                }
                nextphase = SECTION_B;
            }
            if (phase == SECTION_B) {
                nextphase = SECTION_A;
            }
        }
    }
};
#endif //SCAM_TESTBASIC12_H
