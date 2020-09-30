//
// Created by hesselberg on 9/28/20.
//

#ifndef SCAM_TESTBASIC19_H
#define SCAM_TESTBASIC19_H


#include "systemc.h"
#include "Interfaces.h"
#include "../Types.h"

struct TestBasic19 : public sc_module {
    //Sections
    enum Phases {
        SECTION_A, SECTION_B
    };
    Phases phase, nextphase;

    //Constructor
    SC_HAS_PROCESS(TestBasic19);

    TestBasic19(sc_module_name name) :
            b_out("b_out"),
            m_in("m_in") {
        SC_THREAD(fsm);
    }

    //Out-port
    blocking_out<CompoundType> b_out;
    master_in<CompoundType> m_in;

    //Vars
    CompoundType compoundType;

    void fsm() {
        nextphase = SECTION_A;
        while (true) {
            phase = nextphase;
            if (phase == SECTION_A) {
//                b_out->nb_write(compoundType);
                b_out->try_write(compoundType);
                m_in->master_read(compoundType);
                nextphase = SECTION_B;
            }
            if (phase == SECTION_B) {
                nextphase = SECTION_A;
            }
        }
    }
};

#endif //SCAM_TESTBASIC19_H
