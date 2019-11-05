//
// Created by ludwig on 10.10.17.
//

#ifndef PROJECT_SLAVEDAVEBAVE2_H_H
#define PROJECT_SLAVEDAVEBAVE2_H_H


#include "systemc.h"
#include "../Interfaces/Interfaces.h"


// register file output interface
struct RegfileType {
    unsigned int reg_file_01;
    unsigned int reg_file_02;
    unsigned int reg_file_03;
    unsigned int reg_file_04;
    unsigned int reg_file_05;
    unsigned int reg_file_06;
    unsigned int reg_file_07;
    unsigned int reg_file_08;
    unsigned int reg_file_09;
    unsigned int reg_file_10;
    unsigned int reg_file_11;
    unsigned int reg_file_12;
    unsigned int reg_file_13;
    unsigned int reg_file_14;
    unsigned int reg_file_15;
    unsigned int reg_file_16;
    unsigned int reg_file_17;
    unsigned int reg_file_18;
    unsigned int reg_file_19;
    unsigned int reg_file_20;
    unsigned int reg_file_21;
    unsigned int reg_file_22;
    unsigned int reg_file_23;
    unsigned int reg_file_24;
    unsigned int reg_file_25;
    unsigned int reg_file_26;
    unsigned int reg_file_27;
    unsigned int reg_file_28;
    unsigned int reg_file_29;
    unsigned int reg_file_30;
    unsigned int reg_file_31;
};

struct TestBasic0 : public sc_module {
    //Sections
    enum Sections {
        SECTION_A, SECTION_B
    };

    Sections section;
    Sections nextsection;

    //Constructor
    SC_HAS_PROCESS(TestBasic0);

    TestBasic0(sc_module_name name) :
            b_out("b_out"),
            section(SECTION_A),
            nextsection(SECTION_A) {
        SC_THREAD(fsm);
    }

    //Out-port
    blocking_out<int> b_out;

    void fsm() {
        while (true) {
            section = nextsection;
            if (section == SECTION_A) {
                b_out->write(5);
                nextsection = SECTION_B;
            }
            if (section == SECTION_B) {
                nextsection = SECTION_A;
            }
        }
    }
};


#endif //PROJECT_SLAVEDAVEBAVE_H_H
