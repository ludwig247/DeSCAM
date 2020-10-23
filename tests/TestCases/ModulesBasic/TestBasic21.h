//
// Created by hesselberg on 9/28/20.
//

#ifndef SCAM_TESTBASIC21_H
#define SCAM_TESTBASIC21_H


#include "systemc.h"
#include "Interfaces.h"
#include "../Types.h"

struct TestBasic21 : public sc_module {
    //Sections
    enum Phases { SECTION_A, SECTION_B };
    Phases phase, nextphase;

    //Constructor
    SC_HAS_PROCESS(TestBasic21);

    TestBasic21(sc_module_name name) :
            b_out("b_out"),
            m_out("m_out") {
        SC_THREAD(fsm);
    }

    //Out-port
    blocking_out<CompoundType> b_out;
    master_out<CompoundType> m_out;

    //Vars
    CompoundType compoundType;

    void fsm() {
        nextphase = SECTION_A;
        while (true) {
            phase = nextphase;
            if (phase == SECTION_A) {
//                b_out->nb_write(compoundType);//state_11
                b_out->try_write(compoundType);//state_11
                m_out->master_write(compoundType);//state_12
                m_out->master_write(compoundType);
                nextphase = SECTION_B;
            }
            if (phase == SECTION_B) {
                nextphase = SECTION_A;
            }
        }
    }
};


#endif //SCAM_TESTBASIC21_H
