//
// Created by hesselberg on 9/28/20.
//

#ifndef SCAM_TESTMASTERSLAVE4_H
#define SCAM_TESTMASTERSLAVE4_H

#include "systemc.h"
#include "Interfaces.h"
#include "../Types.h"

struct TestMasterSlave04 : public sc_module {
    //Sections
    enum Phases { SECTION_A, SECTION_B};
    Phases phase, nextphase;

    //Constructor
    SC_HAS_PROCESS(TestMasterSlave04);

    TestMasterSlave04(sc_module_name name) :
            s_in2("s_in2"),
            s_in("s_in"),
            val(1337){
        SC_THREAD(fsm);
    }
    //Out-port
    slave_in<int> s_in2;
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
                s_in2->slave_read(val);
                nextphase = SECTION_B;
            }
            if (phase == SECTION_B) {
                nextphase = SECTION_A;
            }
        }
    }
};
#endif //SCAM_TESTMASTERSLAVE4_H
