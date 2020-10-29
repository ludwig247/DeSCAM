//
// Created by hesselberg on 9/28/20.
//

#ifndef SCAM_TESTMASTERSLAVE13_H
#define SCAM_TESTMASTERSLAVE13_H

#include "systemc.h"
#include "Interfaces.h"
#include "../Types.h"

struct TestMasterSlave13 : public sc_module {
    //Sections
    enum Phases { SECTION_A, SECTION_B};
    Phases phase, nextphase;

    //Constructor
    SC_HAS_PROCESS(TestMasterSlave13);

    TestMasterSlave13(sc_module_name name) :
            s_in("s_in"),
            s_in2("s_in2"),
            sh_out("sh_out"),
            m_in("m_in"),
            m_out("m_out"),
            sh_out2("sh_out2") {
        SC_THREAD(fsm);
    }

    //Out-port
    slave_in<int> s_in;
    slave_in<int> s_in2;
    shared_out <int> sh_out;
    master_in<int> m_in;
    master_out<int> m_out;
    shared_out<int> sh_out2;


    //Variable
    int val;
    int save_val;
    bool succ;

    void fsm() {
        nextphase = SECTION_A;
        while (true) {
            phase = nextphase;
            if (phase == SECTION_A) {
                wait(WAIT_TIME, SC_PS);//state
                s_in->slave_read(val);
                save_val += val;
                m_in->master_read(val);
                save_val += val;
                s_in2->slave_read(val);
                save_val += val;
                m_out->master_write(save_val);
                sh_out2->set(save_val);
                sh_out->set(val);
                if(succ) nextphase = SECTION_B;
            }
            if (phase == SECTION_B) {
                wait(WAIT_TIME, SC_PS);//state
                s_in->slave_read(val);
                s_in2->slave_read(val);
                val = val*2;
                sh_out->set(val*2);
                nextphase = SECTION_A;
            }
        }
    }
};
#endif //SCAM_TESTMASTERSLAVE13_H
