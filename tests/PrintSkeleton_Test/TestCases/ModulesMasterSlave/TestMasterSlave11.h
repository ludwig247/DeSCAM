//
// Created by hesselberg on 9/28/20.
//

#ifndef SCAM_TESTMASTERSLAVE11_H
#define SCAM_TESTMASTERSLAVE11_H

#include "systemc.h"
#include "Interfaces.h"

#include "Types.h"

struct TestMasterSlave11 : public sc_module {
    //Sections
    enum Sections {
        SECTION_A, SECTION_B
    };

    Sections section;
    Sections nextsection;

    //Constructor
    SC_HAS_PROCESS(TestMasterSlave11);

    TestMasterSlave11(sc_module_name name) :
            s_in("s_in"),
            s_out("s_out"),
            shared_in("shared_in"),
            section(SECTION_A),
            nextsection(SECTION_A) {
        SC_THREAD(fsm);
    }

    //Out-port
    slave_in<int> s_in;
    shared_out <int> s_out;
    shared_in <bool> shared_in;

    //Variable
    int val;
    bool succ;

    void fsm() {
        while (true) {
            section = nextsection;
            if (section == SECTION_A) {
                wait(WAIT_TIME, SC_PS);//state
                s_in->slave_read(val);
                s_out->set(val);
                shared_in->get(succ);
                if(succ) nextsection = SECTION_B;
            }
            if (section == SECTION_B) {
                wait(WAIT_TIME, SC_PS);//state
                s_in->slave_read(val);
                val = val*2;
                s_out->set(val);
                nextsection = SECTION_A;
            }
        }
    }
};

#endif //SCAM_TESTMASTERSLAVE11_H
