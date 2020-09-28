//
// Created by hesselberg on 9/28/20.
//

#ifndef SCAM_TESTBAISC11_H
#define SCAM_TESTBAISC11_H
struct TestBasic11 : public sc_module {
    //Sections
    enum Sections {
        SECTION_A, SECTION_B
    };

    Sections section;
    Sections nextsection;


    //Constructor
    SC_HAS_PROCESS(TestBasic11);

    TestBasic11(sc_module_name name) :
            b_out("b_out"),
            section(SECTION_A),
            nextsection(SECTION_A) {
        SC_THREAD(fsm);
    }

    //Out-port
    blocking_out<CompoundType> b_out;

    //Vars
    CompoundType compoundType;

    void fsm() {
        while (true) {
            section = nextsection;
            if (section == SECTION_A) {

                b_out->write(compoundType);
                if (compoundType.x > 10) nextsection = SECTION_B;
            }
            if (section == SECTION_B) {
                compoundType.mode = WRITE;
                compoundType.y = false;
                --compoundType.x;
                nextsection = SECTION_A;
            }
        }
    }
};
#endif //SCAM_TESTBAISC11_H
