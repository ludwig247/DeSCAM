//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 6/14/19.
//

#ifndef SCAM_TEST_H
#define SCAM_TEST_H

#include "systemc.h"
#include "Interfaces.h"

struct Test_1 : public sc_module {
    //Sections
    enum Phases {
        READ, PROCESS, WRITE
    };

    Phases phase;
    Phases nextphase;


    //Constructor
    SC_HAS_PROCESS(Test_1);

    Test_1(sc_module_name name) :
            b_in("b_in"),
            b_out("b_out"),
            m_out("m_out"),
            m_in("m_in"),
            reqValue(0),
            rspValue(0) {
        SC_THREAD(fsm);
    }

    blocking_in<int> b_in;
    blocking_out<int> b_out;
    master_out<int> m_out;
    master_in<int> m_in;
    int reqValue;
    int rspValue;

    void fsm() {
        nextphase = READ;
        while (true) {
            phase = nextphase;
            if (phase == READ) {
                b_in->read(reqValue); //State
                nextphase = PROCESS;
            } else if (phase == PROCESS) {
                m_out->write(reqValue); //State
                m_in->read(reqValue); // newly added to check expansion works correctly
                m_out->write(reqValue);
                nextphase = WRITE;
            } else if (phase == WRITE) {
                b_out->write(rspValue); //State
                nextphase = READ;
            }
        }
    }
};
/*
struct Test_1 : public sc_module {
    //Sections
    enum Phases {
        READ, PROCESS, WRITE
    };

    Phases phase;
    Phases nextphase;


    //Constructor
    SC_HAS_PROCESS(Test_1);

    Test_1(sc_module_name name) :
            b_in("b_in"),
            b_out("b_out"),
            m_in("m_in"),
            m_out("m_out"),
            reqValue(0),
            rspValue(0) {
        SC_THREAD(fsm);
    }

    blocking_in<int> b_in;
    blocking_out<int> b_out;
    master_in<int> m_in;
    master_out<int> m_out;
    int reqValue;
    int rspValue;

    void fsm() {
        nextphase = READ;
        while (true) {
            phase = nextphase;
            if (phase == READ) {
                b_in->read(reqValue);
                nextphase = PROCESS;
            } else if (phase == PROCESS) {
                m_out->write(reqValue);
                m_in->read(rspValue);
                nextphase = WRITE;
            } else if (phase == WRITE) {
                b_out->write(rspValue);
                nextphase = READ;
            } else {
                wait(0);
                nextphase = nextphase;
            }
        }
    }
};
*/
#endif //SCAM_TEST_H
