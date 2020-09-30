//
// Created by hesselberg on 9/28/20.
//

#ifndef SCAM_TESTBASIC19_H
#define SCAM_TESTBASIC19_H


#include "systemc.h"
#include "Interfaces.h"
#include "../Types.h"

struct TestBasic19 : public sc_module {
    //Sections
    enum Sections {
        SECTION_A, SECTION_B
    };

    Sections section;
    Sections nextsection;


    //Constructor
    SC_HAS_PROCESS(TestBasic19);

    TestBasic19(sc_module_name name) :
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
                b_out->try_write(compoundType);
                m_in->master_read(compoundType);
                nextsection = SECTION_B;
            }
            if (section == SECTION_B) {
                nextsection = SECTION_A;
            }
        }
    }
};

#endif //SCAM_TESTBASIC19_H
