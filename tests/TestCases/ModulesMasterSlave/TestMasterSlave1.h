//
// Created by hesselberg on 9/28/20.
//

#ifndef SCAM_TESTMASTERSLAVE1_H
#define SCAM_TESTMASTERSLAVE1_H

#include "systemc.h"
#include "Interfaces.h"
#include "../Types.h"

struct TestMasterSlave01 : public sc_module {
    //Sections
    enum Phases { SECTION_A, SECTION_B};
    Phases phase, nextphase;

    //Constructor
    SC_HAS_PROCESS(TestMasterSlave01);

    TestMasterSlave01(sc_module_name name) :
            s_out("s_out") {
        SC_THREAD(fsm);
    }
    //Out-port
    slave_out<int> s_out;

    //Variable
    int val;

    void fsm() {
        nextphase = SECTION_A;
        while (true) {
            phase = nextphase;
            if (phase == SECTION_A) {
                wait(WAIT_TIME, SC_PS);//state //Remark: slave_out_sig will be assignment in reset property the defualt value
                s_out->slave_write(1337);
                nextphase = SECTION_B;
            }
            if (phase == SECTION_B) {
                nextphase = SECTION_A;
            }
        }
    }
};
#endif //SCAM_TESTMASTERSLAVE1_H
