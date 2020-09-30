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
    enum Sections {
        SECTION_A, SECTION_B
    };

    Sections section;
    Sections nextsection;


    //Constructor
    SC_HAS_PROCESS(TestBasic22);

    TestBasic22(sc_module_name name) :
    //m_out("m_out"),
            section(SECTION_A),
            nextsection(SECTION_A),
            test2(30) {
        SC_THREAD(fsm);
    }

    //Out-port
    master_out<test_compound> m_out;
    //Vars
    test_compound test;
    unsigned int test2;

    void fsm() {
        while (true) {
            section = nextsection;
            if (section == SECTION_A) {
                //test.set(9);

                ++test.y;
                test.y = test2;
                ++test2;
                //--test;
                if (test.y > 10) {
                    test.y = test2;
                    m_out->master_write(test);
                } else m_out->master_write(test);

                nextsection = SECTION_B;
            }
            if (section == SECTION_B) {
                nextsection = SECTION_A;
            }
        }
    }
};
#endif //SCAM_TESTBASIC22_H
