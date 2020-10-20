//
// Created by hesselberg on 9/28/20.
//

#ifndef SCAM_TESTBASIC17_H
#define SCAM_TESTBASIC17_H

#include "systemc.h"
#include "Interfaces.h"
#include "../Types.h"

struct TestBasic17 : public sc_module {
    enum Phases {
        SECTION_A, SECTION_B
    };

    Phases phase;
    Phases nextphase;

    //Constructor
    SC_HAS_PROCESS(TestBasic17);

    TestBasic17(sc_module_name name) :
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
                m_in->master_read(compoundType);
//                b_out->nb_write(compoundType);
                b_out->try_write(compoundType);
                nextphase = SECTION_B;
            }
            if (phase == SECTION_B) {
                nextphase = SECTION_A;
            }
        }
    }
};

#endif //SCAM_TESTBASIC17_H
