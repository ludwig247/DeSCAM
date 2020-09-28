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
    enum Sections {
        SECTION_A, SECTION_B
    };

    Sections section;
    Sections nextsection;

    //Constructor
    SC_HAS_PROCESS(TestMasterSlave10);

    TestMasterSlave10(sc_module_name name) :
            s_in("s_in"),
            s_in2("s_in2"),
            s_out("s_out"),
            sharded_in("sharded_in"),
            section(SECTION_A),
            nextsection(SECTION_A) {
        SC_THREAD(fsm);
    }

    //Out-port
    slave_in<int> s_in;
    slave_in<int> s_in2;
    shared_in<int> sharded_in;
    shared_out <int> s_out;

    //Variable
    int val;
    int shared;
    bool succ;

    void fsm() {
        while (true) {
            section = nextsection;
            if (section == SECTION_A) {
                wait(WAIT_TIME, SC_PS);//state
                s_in->slave_read(val);
                s_in2->slave_read(val);
                s_out->set(val);
                if(succ) nextsection = SECTION_B;
            }
            if (section == SECTION_B) {
                wait(WAIT_TIME, SC_PS);//state
                s_in->slave_read(val);
                s_in2->slave_read(val);
                val = val*2;
                sharded_in->get(shared);
                s_out->set(val*2 + shared);
                nextsection = SECTION_A;
            }
        }
    }
};

#endif //SCAM_TESTMASTERSLAVE10_H
