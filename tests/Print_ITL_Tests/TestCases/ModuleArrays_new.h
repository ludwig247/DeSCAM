//
// Created by tobias on 05.12.18.
//

#ifndef PROJECT_MODULEARRAYS_H
#define PROJECT_MODULEARRAYS_H

#include "Interfaces.h"

struct TestArray00 : public sc_module {
    blocking_in<int> b_in;
    blocking_out<int[2]> b_out;
    //Constructor
    SC_HAS_PROCESS(TestArray00);

    TestArray00(sc_module_name name) :
            b_in("m_in"),
            b_out("m_out"){
        SC_THREAD(fsm);
    }

    int test;
    int myArray[2];

    void fsm() {
        while (true) {
            b_in->read(test);
            myArray[0] = test + myArray[1];
            myArray[1]  = test;
            b_out->write(myArray);
        }
    }
};

struct TestArray01 : public sc_module {
    blocking_in<int> m_in;
    blocking_out<int> m_out;
    //Constructor
    SC_HAS_PROCESS(TestArray01);

    TestArray01(sc_module_name name) :
            m_in("m_in"),
            m_out("m_out"){
        SC_THREAD(fsm);
    }

    int rs1;
    int regfile[2];

    void fsm() {
        while (true) {
            m_in->read(rs1);
            regfile[0] = rs1+1;
            regfile[1] = regfile[0];
            m_out->write(regfile[0]);
        }
    }
};

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

struct TestArray03 : public sc_module {
    blocking_in<int[5]> b_in;
    blocking_out<int> b_out;
    //Constructor
    SC_HAS_PROCESS(TestArray03);

    TestArray03(sc_module_name name) :
            b_in("m_in"),
            b_out("m_out"),
            test(2){
        SC_THREAD(fsm);
    }

    int test;
    int myArray[5];

    void fsm() {
        while (true) {
            b_in->read(myArray);
            test = myArray[0] + 1 +1 ;
            b_out->write(test);
        }
    }
};

struct TestArray04 : public sc_module {
    blocking_in<int> m_in;
    blocking_out<int[5]> m_out;
    //Constructor
    SC_HAS_PROCESS(TestArray04);

    TestArray04(sc_module_name name) :
            m_in("m_in"),
            m_out("m_out"){
        SC_THREAD(fsm);
    }

    int test;
    int myArray[5];

    void fsm() {
        while (true) {
            m_in->read(test);
            myArray[0] = test;
            m_out->write(myArray);

        }
    }
};

struct TestArray05 : public sc_module {
    blocking_in<int> b_in;
    blocking_out<int[2]> b_out;
    //Constructor
    SC_HAS_PROCESS(TestArray05);

    TestArray05(sc_module_name name) :
            b_in("m_in"),
            b_out("m_out"){
        SC_THREAD(fsm);
    }

    int test;
    int myArray[2];
    bool succ;

    void fsm() {
        while (true) {
            b_in->try_read(test);
            myArray[0] = test + myArray[1];
            myArray[1]  = test;
            b_out->try_write(myArray, succ);
            if(succ) ++myArray[1];
        }
    }
};


struct TestArray06 : public sc_module {
    //Sections
    enum Sections {
        SECTION_A, SECTION_B
    };

    Sections section;
    Sections nextsection;

    //Constructor
    SC_HAS_PROCESS(TestArray06);

    TestArray06(sc_module_name name) :
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
#endif //PROJECT_MODULEARRAYS_H
