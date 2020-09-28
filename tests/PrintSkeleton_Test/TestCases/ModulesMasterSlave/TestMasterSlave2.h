//
// Created by hesselberg on 9/28/20.
//

#ifndef SCAM_TESTMASTERSLAVE2_H
#define SCAM_TESTMASTERSLAVE2_H

#include "systemc.h"
#include "Interfaces.h"
#include "../Types.h"

struct TestMasterSlave2 : public sc_module {
    //Sections
    enum Sections {
        SECTION_A, SECTION_B
    };

    Sections section;
    Sections nextsection;

    //Constructor
    SC_HAS_PROCESS(TestMasterSlave2);

    TestMasterSlave2(sc_module_name name) :
            s_out("s_out"),
            section(SECTION_A),
            nextsection(SECTION_A),
            val(1337){
        SC_THREAD(fsm);
    }
    //Out-port
    slave_out<int> s_out;

    //Variable
    int val;

    void fsm() {
        while (true) {
            section = nextsection;
            if (section == SECTION_A) {
                s_out->slave_write(val);
                wait(WAIT_TIME, SC_PS);//state
                nextsection = SECTION_B;
            }
            if (section == SECTION_B) {
                nextsection = SECTION_A;
            }
        }
    }
};
#endif //SCAM_TESTMASTERSLAVE2_H
