//
// Created by tobias on 05.12.18.
//

#ifndef PROJECT_MODULEARRAYS_H
#define PROJECT_MODULEARRAYS_H

#include <Interfaces.h>

struct TestArray0 : public sc_module {
    blocking_in<int> b_in;
    blocking_out<int[2]> b_out;
    //Constructor
    SC_HAS_PROCESS(TestArray0);

    TestArray0(sc_module_name name) :
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



struct TestArray1 : public sc_module {
    blocking_in<int> m_in;
    blocking_out<int> m_out;
    //Constructor
    SC_HAS_PROCESS(TestArray1);

    TestArray1(sc_module_name name) :
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



struct TestArray2 : public sc_module {
    blocking_in<int> b_in;
    blocking_out<int> b_out;
    //Constructor
    SC_HAS_PROCESS(TestArray2);

    TestArray2(sc_module_name name) :
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


struct TestArray3 : public sc_module {
    blocking_in<int[5]> b_in;
    blocking_out<int> b_out;
    //Constructor
    SC_HAS_PROCESS(TestArray3);

    TestArray3(sc_module_name name) :
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

struct TestArray4 : public sc_module {
    blocking_in<int> m_in;
    blocking_out<int[5]> m_out;
    //Constructor
    SC_HAS_PROCESS(TestArray4);

    TestArray4(sc_module_name name) :
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

struct TestArray5 : public sc_module {
    blocking_in<int> b_in;
    blocking_out<int[2]> b_out;
    //Constructor
    SC_HAS_PROCESS(TestArray5);

    TestArray5(sc_module_name name) :
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
#endif //PROJECT_MODULEARRAYS_H
