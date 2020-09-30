//
// Created by hesselberg on 9/28/20.
//

#ifndef SCAM_TESTBASIC20_H
#define SCAM_TESTBASIC20_H


#include "systemc.h"
#include "Interfaces.h"
#include "../Types.h"

struct TestBasic20 : public sc_module {
    //Sections
    enum Sections {
        SECTION_A, SECTION_B
    };

    Sections section;
    Sections nextsection;

    enum color_t {RED, GREEN, YELLOW};


    //Constructor
    SC_HAS_PROCESS(TestBasic20);

    TestBasic20(sc_module_name name) :
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
    color_t color;

    void fsm() {
        while (true) {
            section = nextsection;
            if (section == SECTION_A) {
                b_out->try_write(compoundType);
                m_in->master_read(compoundType);
                m_in->master_read(compoundType);
                color = GREEN;
                nextsection = SECTION_B;
            }
            if (section == SECTION_B) {
                nextsection = SECTION_A;
                color = RED;
            }
        }
    }
};

#endif //SCAM_TESTBASIC20_H
