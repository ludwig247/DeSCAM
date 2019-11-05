//
// Created by ludwig on 10.10.17.
//

#ifndef PROJECT_SLAVEDAVEBAVE_H_H
#define PROJECT_SLAVEDAVEBAVE_H_H


#include "systemc.h"
#include "../Interfaces/Interfaces.h"

//struct TestBasic0 : public sc_module {
//    //Sections
//    enum class Phases {
//        SECTION_A, SECTION_B
//    };
//
//    Phases phase;
//    Phases nextphase;
//
//
//    //Constructor
//    SC_HAS_PROCESS(TestBasic0);
//
//    TestBasic0(sc_module_name name) :
//            port_out("b_out"),
//            port_in("b_out") {
//        SC_THREAD(fsm);
//    }
//
//    //Out-port
//    blocking_out<int> port_out;
//    blocking_in<int> port_in;
//
//    //
//    int var,cnt,result;
//
//
//    void fsm() {
//        phase = Phases::SECTION_A;
//        nextphase = Phases::SECTION_A;
//        while (true) {
//            phase = nextphase;
//            if (phase == Phases::SECTION_A) {
//                port_in->read(var);
//                ++var;
//                ++cnt;
//                result = var+ cnt;
//                port_out->write(result);
//                nextphase = Phases::SECTION_B;
//            }
//            if (phase == Phases::SECTION_B) {
//                nextphase = Phases::SECTION_A;
//            }
//        }
//    }
//};




struct test_compound {
    int x;
    unsigned int y;
//    int y;
};

struct TestBasic22 : public sc_module {
    //Sections
    enum Phases { SECTION_A, SECTION_B };
    Phases phase, nextphase;

    //Constructor
    SC_HAS_PROCESS(TestBasic22);

    TestBasic22(sc_module_name name) :
            m_out("m_out"),
            test2(30) {
        SC_THREAD(fsm);
    }

    //Out-port
    master_out<test_compound> m_out;
    //Vars
    test_compound test;
    unsigned int test2;
//    int test2;

    // TODO: an issue with conditions optimization
    void fsm() {
        nextphase = SECTION_A;
        while (true) {
            phase = nextphase;
            if (phase == SECTION_A) {
                //test.set(9);
                ++test.y;
                test.y = test2;
                ++test2;
                //--test;
                if (test.y > 10) {
                    test.y = test2;
                    m_out->master_write(test);
                } else
                    m_out->master_write(test);

                nextphase = SECTION_B;
            }
            if (phase == SECTION_B) {
                nextphase = SECTION_A;
            }
        }
    }
};

#endif //PROJECT_SLAVEDAVEBAVE_H_H
