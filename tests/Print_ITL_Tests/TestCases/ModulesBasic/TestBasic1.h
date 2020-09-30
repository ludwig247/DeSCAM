//
// Created by hesselberg on 9/28/20.
//

#ifndef SCAM_TESTBASIC1_H
#define SCAM_TESTBASIC1_H

#include "systemc.h"
#include "Interfaces.h"
#include "../Types.h"

struct TestBasic1 : public sc_module {
    //Sections
    enum Sections {
        SECTION_A, SECTION_B
    };

    Sections section;
    Sections nextsection;


    //Constructor
    SC_HAS_PROCESS(TestBasic1);

    TestBasic1(sc_module_name name) :
            b_in("b_in"),
            section(SECTION_A),
            nextsection(SECTION_A) {
        SC_THREAD(fsm);
    }

    //Out-port
    blocking_in<int> b_in;
    //Vars
    int x;

    void fsm() {
        while (true) {
            section = nextsection;
            if (section == SECTION_A) {
                b_in->read(x);
                nextsection = SECTION_B;
            }
            if (section == SECTION_B) {
                nextsection = SECTION_A;
            }
        }
    }
};
#endif //SCAM_TESTBASIC1_H
