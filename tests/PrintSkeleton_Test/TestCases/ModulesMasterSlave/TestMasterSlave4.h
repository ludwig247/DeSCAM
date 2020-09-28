//
// Created by hesselberg on 9/28/20.
//

#ifndef SCAM_TESTMASTERSLAVE4_H
#define SCAM_TESTMASTERSLAVE4_H

#include "systemc.h"
#include "Interfaces.h"

#include "Types.h"

struct TestMasterSlave4 : public sc_module {
    //Sections
    enum Sections {
        SECTION_A, SECTION_B
    };

    Sections section;
    Sections nextsection;

    //Constructor
    SC_HAS_PROCESS(TestMasterSlave4);

    TestMasterSlave4(sc_module_name name) :
            s_in2("s_in2"),
            s_in("s_in"),
            section(SECTION_A),
            nextsection(SECTION_A),
            val(1337){
        SC_THREAD(fsm);
    }
    //Out-port
    slave_in<int> s_in2;
    slave_in<int> s_in;

    //Variable
    int val;

    void fsm() {
        while (true) {
            section = nextsection;
            if (section == SECTION_A) {
                wait(WAIT_TIME, SC_PS);//state
                s_in->slave_read(val);
                s_in2->slave_read(val);
                nextsection = SECTION_B;
            }
            if (section == SECTION_B) {
                nextsection = SECTION_A;
            }
        }
    }
};
#endif //SCAM_TESTMASTERSLAVE4_H
