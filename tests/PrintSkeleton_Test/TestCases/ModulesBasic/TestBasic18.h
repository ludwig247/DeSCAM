//
// Created by hesselberg on 9/28/20.
//

#ifndef SCAM_TESTBASIC18_H
#define SCAM_TESTBASIC18_H


#include "systemc.h"
#include "Interfaces.h"
#include "../Types.h"

struct TestBasic18 : public sc_module {
    //Sections
    enum Sections {
        SECTION_A, SECTION_B
    };

    Sections section;
    Sections nextsection;


    //Constructor
    SC_HAS_PROCESS(TestBasic18);

    TestBasic18(sc_module_name name) :
            b_out("b_out"),
            m_in("m_in"),
            section(SECTION_A),
            nextsection(SECTION_A) {
        SC_THREAD(fsm);
    }

    //Out-port
    blocking_out<CompoundType> b_out;
    master_in<CompoundType> m_in;

    //Vars
    CompoundType compoundType;

    void fsm() {
        while (true) {
            section = nextsection;
            if (section == SECTION_A) {
                m_in->master_read(compoundType);
                b_out->write(compoundType);
                nextsection = SECTION_B;
            }
            if (section == SECTION_B) {
                nextsection = SECTION_A;
            }
        }
    }
};

#endif //SCAM_TESTBASIC18_H
