//
// Created by hesselberg on 9/28/20.
//

#ifndef SCAM_TESTBASIC23_H
#define SCAM_TESTBASIC23_H


#include "systemc.h"
#include "Interfaces.h"
#include "../Types.h"

struct TestBasic23 : public sc_module {
    //Sections
    enum Sections {
        SECTION_A, SECTION_B
    };

    Sections section;
    Sections nextsection;


    //Constructor
    SC_HAS_PROCESS(TestBasic23);

    TestBasic23(sc_module_name name) :
    //m_out("m_out"),
            section(SECTION_A),
            nextsection(SECTION_A),
            b_out("b_out"),
            b_out2("b_out2"),
            val_unsigned(13),
            val_signed(-7) {
        SC_THREAD(fsm);
    }

    //Out-port
    blocking_out<unsigned int> b_out;
    blocking_out<int> b_out2;
    //Vars
    unsigned int val_unsigned;
    int val_signed;

    void fsm() {
        while (true) {
            section = nextsection;
            if (section == SECTION_A) {
                b_out->write(val_unsigned>>2);
                b_out->write(val_unsigned<<2);
                b_out->write(val_unsigned&2);
                b_out->write(val_unsigned|2);

                if ((val_unsigned % 2) == 0) nextsection = SECTION_B;
                if ((val_unsigned & 2) == 0) nextsection = SECTION_B;
                if ((val_unsigned | 2) == 0) nextsection = SECTION_B;
                if ((val_unsigned >> 2) == 0) nextsection = SECTION_B;
                if ((val_unsigned << 2) == 0) nextsection = SECTION_B;

                nextsection = SECTION_B;
            }
            if (section == SECTION_B) {

                b_out2->write(val_signed>>2);
                b_out2->write(val_signed<<2);
                b_out2->write(val_signed&2);
                b_out2->write(val_signed|2);

                if ((val_signed % 2) == 0) nextsection = SECTION_B;
                if ((val_signed & 2) == 0) nextsection = SECTION_B;
                if ((val_signed | 2) == 0) nextsection = SECTION_B;
                if ((val_signed >> 2) == 0) nextsection = SECTION_B;
                if ((val_signed << 2) == 0) nextsection = SECTION_B;


                nextsection = SECTION_A;
            }
        }
    }
};

#endif //SCAM_TESTBASIC23_H
