//
// Created by hesselberg on 9/28/20.
//

#ifndef SCAM_TESTBASIC16_H
#define SCAM_TESTBASIC16_H


#include "systemc.h"
#include "Interfaces.h"
#include "../Types.h"

//TODO: TestBasic16 ... actually compoundType.x doesn't need to be a register ... if there is time fix this
struct TestBasic16 : public sc_module {
    //Sections
    enum Sections {
        SECTION_A, SECTION_B
    };

    Sections section;
    Sections nextsection;


    //Constructor
    SC_HAS_PROCESS(TestBasic16);

    TestBasic16(sc_module_name name) :
            b_out("b_out"),
            b_in("b_in"),
            section(SECTION_A),
            nextsection(SECTION_A) {
        SC_THREAD(fsm);
    }

    //Out-port
    blocking_out<CompoundType> b_out;
    blocking_in<CompoundType> b_in;

    //Vars
    CompoundType compoundType;

    void fsm() {
        while (true) {
            section = nextsection;
            if (section == SECTION_A) {
                b_in->read(compoundType);
                ++compoundType.x;
                if (compoundType.mode == WRITE) {
                    nextsection = SECTION_B;
                }

            }
            if (section == SECTION_B) {
                b_out->try_write(compoundType);
                --compoundType.x;
                compoundType.y = false;
                nextsection = SECTION_A;
            }
        }
    }
};

#endif //SCAM_TESTBASIC16_H