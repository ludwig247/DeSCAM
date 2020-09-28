//
// Created by hesselberg on 9/28/20.
//

#ifndef SCAM_TESTMASTERSLAVE13_H
#define SCAM_TESTMASTERSLAVE13_H

#include "systemc.h"
#include "Interfaces.h"

#include "Types.h"

struct TestMasterSlave13 : public sc_module {
    //Sections
    enum Sections {
        SECTION_A, SECTION_B
    };

    Sections section;
    Sections nextsection;

    //Constructor
    SC_HAS_PROCESS(TestMasterSlave13);

    TestMasterSlave13(sc_module_name name) :
            s_in("s_in"),
            s_in2("s_in2"),
            s_out("s_out"),
            m_in("m_in"),
            m_out("m_out"),
            shared_out("shared_out"),
            section(SECTION_A),
            nextsection(SECTION_A) {
        SC_THREAD(fsm);
    }

    //Out-port
    slave_in<int> s_in;
    slave_in<int> s_in2;
    shared_out <int> s_out;
    master_in<int> m_in;
    master_out<int> m_out;
    shared_out<int> shared_out;


    //Variable
    int val;
    int save_val;
    bool succ;

    void fsm() {
        while (true) {
            section = nextsection;
            if (section == SECTION_A) {
                wait(WAIT_TIME, SC_PS);//state
                s_in->slave_read(val);
                save_val += val;
                m_in->master_read(val);
                save_val += val;
                s_in2->slave_read(val);
                save_val += val;
                m_out->master_write(save_val);
                shared_out->set(save_val);
                s_out->set(val);
                if(succ) nextsection = SECTION_B;
            }
            if (section == SECTION_B) {
                wait(WAIT_TIME, SC_PS);//state
                s_in->slave_read(val);
                s_in2->slave_read(val);
                val = val*2;
                s_out->set(val*2);
                nextsection = SECTION_A;
            }
        }
    }
};
#endif //SCAM_TESTMASTERSLAVE13_H
