//
// Created by hesselberg on 9/28/20.
//

#ifndef SCAM_TESTMASTERSLAVE9_H
#define SCAM_TESTMASTERSLAVE9_H

#include "systemc.h"
#include "Interfaces.h"
#include "../Types.h"

struct TestMasterSlave09 : public sc_module {
    //Sections
    enum Phases { SECTION_A, SECTION_B};
    Phases phase, nextphase;

    //Constructor
    SC_HAS_PROCESS(TestMasterSlave09);

    TestMasterSlave09(sc_module_name name) :
            s_in("s_in"),
            sh_out("sh_out") {
        SC_THREAD(fsm);
    }

    //Out-port
    slave_in<int> s_in;
    shared_out <int> sh_out;

    //Variable
    int val;

    void fsm() {
        nextphase = SECTION_A;
        while (true) {
            phase = nextphase;
            if (phase == SECTION_A) {
                sh_out->set(val);
                wait(WAIT_TIME, SC_PS);//state //Remark: it differs! having the wait statement before of the shared output or after
                s_in->slave_read(val);
                nextphase = SECTION_B;
            }
            if (phase == SECTION_B) {
                nextphase = SECTION_A;
            }
        }
    }
};
#endif //SCAM_TESTMASTERSLAVE9_H
