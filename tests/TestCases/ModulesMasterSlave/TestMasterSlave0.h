//
// Created by hesselberg on 9/28/20.
//

#ifndef SCAM_TESTMASTERSLAVE0_H
#define SCAM_TESTMASTERSLAVE0_H

#include "systemc.h"
#include "Interfaces.h"
#include "../Types.h"


struct TestMasterSlave00 : public sc_module {
    //Sections
    enum Phases { SECTION_A, SECTION_B};
    Phases phase, nextphase;

    //Constructor
    SC_HAS_PROCESS(TestMasterSlave00);

    TestMasterSlave00(sc_module_name name) :
            s_in("s_in") {
        SC_THREAD(fsm);
    }
    //Out-port
    slave_in<int> s_in;

    //Variable
    int val;

    void fsm() {
        nextphase = SECTION_A;
        while (true) {
            phase = nextphase;
            if (phase == SECTION_A) {
                wait(WAIT_TIME, SC_PS);//state
                s_in->slave_read(val);
                nextphase = SECTION_B;
            }
            if (phase == SECTION_B) {
                nextphase = SECTION_A;
            }
        }
    }
};
#endif //SCAM_TESTMASTERSLAVE0_H
