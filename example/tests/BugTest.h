//
// Created by ludwig on 10.10.17.
//

#ifndef PROJECT_SLAVEDAVEBAVE2_H_H
#define PROJECT_SLAVEDAVEBAVE2_H_H


#include "systemc.h"
#include "../Interfaces/Interfaces.h"


// register file output interface

struct TestArray02 : public sc_module {
    blocking_in<int> b_in;
    blocking_out<int> b_out;
    //Constructor
    SC_HAS_PROCESS(TestArray02);

    TestArray02(sc_module_name name) :
            b_in("m_in"),
            b_out("m_out"),
            test(2){
        SC_THREAD(fsm);
    }

    int test;
    int myArray[5];

    void fsm() {
        while (true) {
            b_in->read(test);
            test = test;
            myArray[0] = myArray[test];
            b_out->write(myArray[0]);
        }
    }
};



struct TestArrayX : public sc_module {
    //Sections
    enum Sections {
        SECTION_A, SECTION_B
    };

    Sections section;
    Sections nextsection;

    //Constructor
    SC_HAS_PROCESS(TestArrayX);

    TestArrayX(sc_module_name name) :
            b_out("b_out"),
            section(SECTION_A),
            nextsection(SECTION_A) {
        SC_THREAD(fsm);
    }

    //Out-port
    master_in<unsigned[4]> m_in;
    blocking_out<unsigned> b_out;

    unsigned tmp[4];

    unsigned foobar(unsigned num) const{
        return num;
    }

    void fsm() {
        while (true) {
            m_in->master_read(tmp);
            b_out->write(tmp[foobar(0)]);
        }
    }
};


#endif //PROJECT_SLAVEDAVEBAVE_H_H
