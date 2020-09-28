//
// Created by hesselberg on 9/28/20.
//

#ifndef SCAM_TESTBASIC12_H
#define SCAM_TESTBASIC12_H
struct TestBasic12 : public sc_module {
    //Sections
    enum Sections {
        SECTION_A, SECTION_B
    };

    Sections section;
    Sections nextsection;


    //Constructor
    SC_HAS_PROCESS(TestBasic12);

    TestBasic12(sc_module_name name) :
            m_out("m_out"),
            b_in("b_in"),
            section(SECTION_A),
            nextsection(SECTION_A) {
        SC_THREAD(fsm);
    }

    //Out-port
    master_out<int> m_out;
    blocking_in<CompoundType> b_in;

    //Vars
    CompoundType compoundType;

    void fsm() {
        while (true) {
            section = nextsection;
            if (section == SECTION_A) {
                b_in->read(compoundType);
                if (compoundType.x >= 5) {
                    m_out->master_write(compoundType.x);
                }
                nextsection = SECTION_B;
            }
            if (section == SECTION_B) {
                nextsection = SECTION_A;
            }
        }
    }
};
#endif //SCAM_TESTBASIC12_H
