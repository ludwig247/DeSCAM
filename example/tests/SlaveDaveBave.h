//
// Created by ludwig on 10.10.17.
//

#ifndef PROJECT_SLAVEDAVEBAVE_H_H
#define PROJECT_SLAVEDAVEBAVE_H_H

// just for testing upstream

#include "systemc.h"
#include "../Interfaces/Interfaces.h"

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
            port_out("b_out"),
            port_in("b_out"),
            section(SECTION_A),
            nextsection(SECTION_A) {
        SC_THREAD(fsm);
    }

    //Out-port
    blocking_out<int> port_out;
    blocking_in<int> port_in;

    //
    int var,cnt,result;


    void fsm() {
        while (true) {
            section = nextsection;
            if (section == SECTION_A) {
                port_in->read(var);
                ++var;
                ++cnt;
                result = var+ cnt;
                port_out->write(result);
                nextsection = SECTION_B;
            }
            if (section == SECTION_B) {
                nextsection = SECTION_A;
            }
        }
    }
};




#endif //PROJECT_SLAVEDAVEBAVE_H_H
