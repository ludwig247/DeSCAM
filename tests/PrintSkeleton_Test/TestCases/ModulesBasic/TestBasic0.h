//
// Created by hesselberg on 9/28/20.
//

#ifndef SCAM_TESTBASIC0_H
#define SCAM_TESTBASIC0_H
#include "systemc.h"
#include "Interfaces.h"
#include "Types.h"

struct TestBasic0 : public sc_module {
    //Sections
    enum Sections {
        SECTION_A, SECTION_B
    };

    Sections section;
    Sections nextsection;

    //Constructor
    SC_HAS_PROCESS(TestBasic0);

    TestBasic0(sc_module_name name) :
            b_out("b_out"),
            section(SECTION_A),
            nextsection(SECTION_A) {
        SC_THREAD(fsm);
    }

    //Out-port
    blocking_out<int> b_out;

    void fsm() {
        while (true) {
            section = nextsection;
            if (section == SECTION_A) {
                b_out->write(5);
                nextsection = SECTION_B;
            }
            if (section == SECTION_B) {
                nextsection = SECTION_A;
            }
        }
    }
};
#endif //SCAM_TESTBASIC0_H
