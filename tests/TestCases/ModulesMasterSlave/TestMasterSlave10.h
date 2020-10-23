//
// Created by hesselberg on 9/28/20.
//

#ifndef SCAM_TESTMASTERSLAVE10_H
#define SCAM_TESTMASTERSLAVE10_H

#include "systemc.h"
#include "Interfaces.h"
#include "../Types.h"

struct TestMasterSlave10 : public sc_module {
    //Sections
    enum Phases { SECTION_A, SECTION_B};
    Phases phase, nextphase;

    //Constructor
    SC_HAS_PROCESS(TestMasterSlave10);

    TestMasterSlave10(sc_module_name name) :
            s_in("s_in"),
            s_in2("s_in2"),
            sh_out("sh_out"),
            sh_in("sh_in") {
        SC_THREAD(fsm);
    }

    //Out-port
    slave_in<int> s_in;
    slave_in<int> s_in2;
    shared_in<int> sh_in;
    shared_out <int> sh_out;

    //Variable
    int val;
    int shared;
    bool succ;

    void fsm() {
        nextphase = SECTION_A;
        while (true) {
            phase = nextphase;
            if (phase == SECTION_A) {
                wait(WAIT_TIME, SC_PS);//state
                s_in->slave_read(val);
                s_in2->slave_read(val);
                sh_out->set(val);
                if(succ) nextphase = SECTION_B;//FIXME:: this should be unreachable
                // but because the backtrack only goes until the while(true) statement, then we can't exclude it
                // Ibra's work should detect it.
            }
            if (phase == SECTION_B) {
                wait(WAIT_TIME, SC_PS);
                s_in->slave_read(val); //FIXME: original properties are not as expected!
                s_in2->slave_read(val);
                val = val*2;
                sh_in->get(shared);//FIXME: this variable should disappear because we always read from sh_in
                sh_out->set(val*2 + shared);
                nextphase = SECTION_A;
            }
        }
    }
};

#endif //SCAM_TESTMASTERSLAVE10_H
