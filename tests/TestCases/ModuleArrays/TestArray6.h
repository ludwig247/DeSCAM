//
// Created by hesselberg on 9/30/20.
//

#ifndef SCAM_TESTARRAY6_H
#define SCAM_TESTARRAY6_H

#include "Interfaces.h"


struct TestArray06 : public sc_module {
    //Sections
    enum Sections {
        SECTION_A, SECTION_B
    };

    Sections section;
    Sections nextsection;

    //Constructor
    SC_HAS_PROCESS(TestArray06);

    TestArray06(sc_module_name name) :
            b_out("b_out"),
            section(SECTION_A),
            nextsection(SECTION_A) {
        SC_THREAD(fsm);
    }

    //Out-port
    master_in<unsigned[4]> m_in;
    blocking_out<unsigned> b_out;

    unsigned tmp[4];

    unsigned foobar(unsigned num) const{
        return num;
    }

    void fsm() {
        while (true) {
            m_in->master_read(tmp);
            b_out->write(tmp[foobar(0)]);
        }
    }
};

#endif //SCAM_TESTARRAY6_H
