//
// Created by hesselberg on 9/28/20.
//

#ifndef SCAM_TESTMASTERSLAVE1_H
#define SCAM_TESTMASTERSLAVE1_H

#include "systemc.h"
#include "Interfaces.h"

#include "Types.h"

struct TestMasterSlave1 : public sc_module {
    //Sections
    enum Sections {
        SECTION_A, SECTION_B
    };

    Sections section;
    Sections nextsection;

    //Constructor
    SC_HAS_PROCESS(TestMasterSlave1);

    TestMasterSlave1(sc_module_name name) :
            s_out("s_out"),
            section(SECTION_A),
            nextsection(SECTION_A) {
        SC_THREAD(fsm);
    }
    //Out-port
    slave_out<int> s_out;

    //Variable
    int val;

    void fsm() {
        while (true) {
            if (section == SECTION_A) {
                s_out->slave_write(1337);
                wait(WAIT_TIME, SC_PS);//state
                nextsection = SECTION_B;
            }
            else if (section == SECTION_B) {
                nextsection = SECTION_A;
            }
            section = nextsection;
        }
    }
};
#endif //SCAM_TESTMASTERSLAVE1_H
