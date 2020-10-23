//
// Created by hesselberg on 9/28/20.
//

#ifndef SCAM_TESTMASTERSLAVE11_H
#define SCAM_TESTMASTERSLAVE11_H

#include "systemc.h"
#include "Interfaces.h"
#include "../Types.h"

struct TestMasterSlave11 : public sc_module {
    //Sections
    enum Phases { SECTION_A, SECTION_B};
    Phases phase, nextphase;

    //Constructor
    SC_HAS_PROCESS(TestMasterSlave11);

    TestMasterSlave11(sc_module_name name) :
            s_in("s_in"),
            sh_out("sh_out"),
            sh_in("sh_in") {
        SC_THREAD(fsm);
    }

    //Out-port
    slave_in<int> s_in;
    shared_out <int> sh_out;
    shared_in <bool> sh_in;

    //Variable
    int val;
    bool succ;

    void fsm() {
        nextphase = SECTION_A;
        while (true) {
            phase = nextphase;
            if (phase == SECTION_A) {
                wait(WAIT_TIME, SC_PS);//state
                s_in->slave_read(val);
                sh_out->set(val);
                sh_in->get(succ);
                if(succ) nextphase = SECTION_B;
            }
            if (phase == SECTION_B) {
                wait(WAIT_TIME, SC_PS);//state
                s_in->slave_read(val);
                val = val*2;
                sh_out->set(val);
                nextphase = SECTION_A;
            }
        }
    }
};

#endif //SCAM_TESTMASTERSLAVE11_H
