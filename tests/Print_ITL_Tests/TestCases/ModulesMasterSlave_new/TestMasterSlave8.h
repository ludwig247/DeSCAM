//
// Created by hesselberg on 9/28/20.
//

#ifndef SCAM_TESTMASTERSLAVE8_H
#define SCAM_TESTMASTERSLAVE8_H

#include "systemc.h"
#include "Interfaces.h"
#include "../Types.h"

struct TestMasterSlave8 : public sc_module {
    //Sections
    enum Sections {
        SECTION_A, SECTION_B
    };

    Sections section;
    Sections nextsection;

    //Constructor
    SC_HAS_PROCESS(TestMasterSlave8);

    TestMasterSlave8(sc_module_name name) :
            s_in("s_in"),
            s_out("s_out"),
            section(SECTION_A),
            nextsection(SECTION_A) {
        SC_THREAD(fsm);
    }

    //Out-port
    slave_in<int> s_in;
    slave_out<int> s_out;

    //Variable
    int val;

    void fsm() {
        while (true) {
            section = nextsection;
            if (section == SECTION_A) {
                wait(WAIT_TIME, SC_PS);//state
                s_in->slave_read(val);
                s_out->slave_write(val);
                if(val > 10)  nextsection = SECTION_B;
            }
            if (section == SECTION_B) {
                wait(WAIT_TIME, SC_PS);//state
                s_in->slave_read(val);
                ++val;
                s_out->slave_write(val);
                nextsection = SECTION_A;
            }
        }
    }
};
#endif //SCAM_TESTMASTERSLAVE8_H
