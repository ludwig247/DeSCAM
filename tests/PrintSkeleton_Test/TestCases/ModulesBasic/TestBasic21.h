//
// Created by hesselberg on 9/28/20.
//

#ifndef SCAM_TESTBASIC21_H
#define SCAM_TESTBASIC21_H


#include "systemc.h"
#include "Interfaces.h"
#include "Types.h"

struct TestBasic21 : public sc_module {
    //Sections
    enum Sections {
        SECTION_A, SECTION_B
    };

    Sections section;
    Sections nextsection;


    //Constructor
    SC_HAS_PROCESS(TestBasic21);

    TestBasic21(sc_module_name name) :
            b_out("b_out"),
            m_out("m_out"),
            section(SECTION_A),
            nextsection(SECTION_A) {
        SC_THREAD(fsm);
    }

    //Out-port
    blocking_out<CompoundType> b_out;
    master_out<CompoundType> m_out;

    //Vars
    CompoundType compoundType;

    void fsm() {
        while (true) {
            section = nextsection;
            if (section == SECTION_A) {
                b_out->try_write(compoundType);
                m_out->master_write(compoundType);
                //m_out->write(compoundType);
                nextsection = SECTION_B;
            }
            if (section == SECTION_B) {
                nextsection = SECTION_A;
            }
        }
    }
};

#endif //SCAM_TESTBASIC21_H
