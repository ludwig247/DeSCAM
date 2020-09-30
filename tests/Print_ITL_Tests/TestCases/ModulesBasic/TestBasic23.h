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
    enum Phases { SECTION_A, SECTION_B };
    Phases phase, nextphase;

    //Constructor
    SC_HAS_PROCESS(TestBasic23);

    TestBasic23(sc_module_name name) :
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
        nextphase = SECTION_A;
        while (true) {
            phase = nextphase;
            if (phase == SECTION_A) {
                b_out->write(val_unsigned>>2);
                b_out->write(val_unsigned<<2);
                b_out->write(val_unsigned&2);
                b_out->write(val_unsigned|2);

                if ((val_unsigned % 2) == 0) nextphase = SECTION_B;
                if ((val_unsigned & 2) == 0) nextphase = SECTION_B;
                if ((val_unsigned | 2) == 0) nextphase = SECTION_B;
                if ((val_unsigned >> 2) == 0) nextphase = SECTION_B;
                if ((val_unsigned << 2) == 0) nextphase = SECTION_B;

                nextphase = SECTION_B;
            }
            if (phase == SECTION_B) {

                b_out2->write(val_signed>>2);
                b_out2->write(val_signed<<2);
                b_out2->write(val_signed&2);
                b_out2->write(val_signed|2);

                if ((val_signed % 2) == 0) nextphase = SECTION_B;
                if ((val_signed & 2) == 0) nextphase = SECTION_B;
                if ((val_signed | 2) == 0) nextphase = SECTION_B;
                if ((val_signed >> 2) == 0) nextphase = SECTION_B;
                if ((val_signed << 2) == 0) nextphase = SECTION_B;

                nextphase = SECTION_A;
            }
        }
    }
};

#endif //SCAM_TESTBASIC23_H
