//
// Created by hesselberg on 9/28/20.
//

#ifndef SCAM_TESTBASIC20_H
#define SCAM_TESTBASIC20_H


#include "systemc.h"
#include "Interfaces.h"
#include "../Types.h"

struct TestBasic20 : public sc_module {
    //Sections
    enum Phases { SECTION_A, SECTION_B };
    Phases phase, nextphase;

    //Constructor
    SC_HAS_PROCESS(TestBasic20);

    TestBasic20(sc_module_name name) :
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
//                b_out->nb_write(compoundType);//state_11
                b_out->try_write(compoundType);//state_11
                m_in->master_read(compoundType);
                m_in->master_read(compoundType);//state_13
                nextphase = SECTION_B;
            }
            if (phase == SECTION_B) {
                nextphase = SECTION_A;
            }
        }
    }
};

#endif //SCAM_TESTBASIC20_H
