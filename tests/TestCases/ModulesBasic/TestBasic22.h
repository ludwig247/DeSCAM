//
// Created by hesselberg on 9/28/20.
//

#ifndef SCAM_TESTBASIC22_H
#define SCAM_TESTBASIC22_H


#include "systemc.h"
#include "Interfaces.h"
#include "../Types.h"

struct TestBasic22 : public sc_module {
    //Sections
    enum Phases { SECTION_A, SECTION_B };
    Phases phase, nextphase;

    //Constructor
    SC_HAS_PROCESS(TestBasic22);

    TestBasic22(sc_module_name name) :
            m_out("m_out"),
            test2(30) {
        SC_THREAD(fsm);
    }

    //Out-port
    master_out<test_compound> m_out;
    //Vars
    test_compound test;
    unsigned int test2;
//    int test2;

    // TODO: an issue with conditions optimization
    void fsm() {
        nextphase = SECTION_A;
        while (true) {
            phase = nextphase;
            if (phase == SECTION_A) {
                //test.set(9);
                ++test.y;
                test.y = test2;
                ++test2;
                //--test;
                if (test.y > 10) {
                    test.y = test2;
                    m_out->master_write(test);
                } else
                    m_out->master_write(test);

                nextphase = SECTION_B;
            }
            if (phase == SECTION_B) {
                nextphase = SECTION_A;
            }
        }
    }
};
#endif //SCAM_TESTBASIC22_H
