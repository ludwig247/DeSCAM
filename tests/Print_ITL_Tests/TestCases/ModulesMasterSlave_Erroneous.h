//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 12.08.19.
//

#ifndef PROJECT_MODULES_MS_H
#define PROJECT_MODULES_MS_H

#include "systemc.h"
#include "../../../example/Interfaces/Interfaces.h"
//#include "Interfaces.h"

/*
struct TestMasterSlave05 : public sc_module {
    //Sections
    enum Phases { SECTION_A, SECTION_B};
    Phases phase, nextphase;

    //Constructor
    SC_HAS_PROCESS(TestMasterSlave05);

    TestMasterSlave05(sc_module_name name) :
            s_in2("s_in2"),
            s_in("s_in"),
            s_out("s_out"),
            val(1337){
        SC_THREAD(fsm);
    }
    //Out-port
    slave_in<int> s_in2;
    slave_in<int> s_in;
    slave_out<int> s_out;

    //Variable
    int val;

    void fsm() {
        nextphase = SECTION_A;
        while (true) {
            phase = nextphase;
            if (phase == SECTION_A) {
                wait(WAIT_TIME, SC_PS);//state
                s_in->slave_read(val);
                s_out->slave_write(val);
                s_in2->slave_read(val);//triggers error: passing the outgoing ports before the ingoing ports!
                nextphase = SECTION_B;
            }
            if (phase == SECTION_B) {
                nextphase = SECTION_A;
            }
        }
    }
};
//*/

/*
/// having a blocking comm in a slave module throws an error
struct TestMasterSlave_0X : public sc_module {

    //Constructor
    SC_HAS_PROCESS(TestMasterSlave_0X);

    TestMasterSlave_0X(sc_module_name name) :
            b_out("b_out"),
            s_in("s_in"),
            s_out("s_out"),
            s_inData(0),
            var1(5) {
        SC_THREAD(fsm);
    }

    //Out-port
    blocking_out<int> b_out;
    slave_in<int> s_in;
    slave_out<int> s_out;

    //Vars
    int var1;
    int s_inData;

    void fsm() {
        while (true) {
            b_out->write(var1);
            s_in->slave_read(s_inData);
            s_out->slave_write(s_inData);
        }
    }
};
//*/

/*
/// reset property should not have any slave communications in it
struct TestMasterSlave_1X : public sc_module {

    //Constructor
    SC_HAS_PROCESS(TestMasterSlave_1X);

    TestMasterSlave_1X(sc_module_name name) :
            s_in("s_in"),
            s_out("s_out"),
            s_inData(0),
            var1(5) {
        SC_THREAD(fsm);
    }

    //Out-port
    slave_in<int> s_in;
    slave_out<int> s_out;

    //Vars
    int var1;
    int s_inData;

    void fsm() {
        while (true) {
            s_in->slave_read(s_inData);     // this statement will be included in the reset property and trigger an error
            s_out->slave_write(s_inData);   // this statement will be included in the reset property and trigger an error
            wait(WAIT_TIME, SC_PS);//state
        }
    }
};
//*/

/*
/// coloring a master in a slave module throws an error
struct TestMasterSlave_2X : public sc_module {

    //Constructor
    SC_HAS_PROCESS(TestMasterSlave_2X);

    TestMasterSlave_2X(sc_module_name name) :
            s_in_1("s_in_1"),
            s_in_2("s_in_2"),
            s_in_3("s_in_3"),
            s_out_1("s_out_1"),
            s_out_2("s_out_2"),
            s_out_3("s_out_3"),
            m_in_1("m_in_1"),
            m_out_1("m_out_1"),
            mdata(0),
            data1(0),
            data2(0),
            data3(0) {
        SC_THREAD(fsm);
    }

    //Out-port
    slave_in<int> s_in_1;
    slave_in<int> s_in_2;
    slave_in<int> s_in_3;
    slave_out<int> s_out_1;
    slave_out<int> s_out_2;
    slave_out<int> s_out_3;
    master_in<int> m_in_1;
    master_out<int> m_out_1;

    //Vars
    int data1;
    int data2;
    int data3;
    int mdata;

    void fsm() {
        while (true) {
            wait(WAIT_TIME, SC_PS);

            s_in_1->slave_read(data1);//state
            s_in_2->slave_read(data2);
            s_in_3->slave_read(data3);

            m_out_1->master_write(mdata);//colored because of read (m_in_1) after write (m_out_1)

            s_out_1->slave_write(data1);
            s_out_2->slave_write(data2);
            s_out_3->slave_write(data3);

            m_in_1->master_read(mdata);
        }
    }
};
//*/

/*
/// passing an input port more than once!
struct TestMasterSlave_3X : public sc_module {

    //Constructor
    SC_HAS_PROCESS(TestMasterSlave_3X);

    TestMasterSlave_3X(sc_module_name name) :
            s_in_1("s_in_1"),
            s_in_2("s_in_2"),
            s_in_3("s_in_3"),
            s_out_1("s_out_1"),
            s_out_2("s_out_2"),
            s_out_3("s_out_3"),
            data1(0),
            data2(0),
            data3(0) {
        SC_THREAD(fsm);
    }

    //Out-port
    slave_in<int> s_in_1;
    slave_in<int> s_in_2;
    slave_in<int> s_in_3;
    slave_out<int> s_out_1;
    slave_out<int> s_out_2;
    slave_out<int> s_out_3;

    //Vars
    int data1;
    int data2;
    int data3;

    void fsm() {
        while (true) {
            wait(WAIT_TIME, SC_PS);//state

            s_in_1->slave_read(data1);
            s_in_2->slave_read(data2);
            s_in_3->slave_read(data3);

            s_out_1->slave_write(data1);
            s_out_2->slave_write(data2);
            s_out_3->slave_write(data3);

            s_in_1->slave_read(data1);//triggers an error
            s_in_2->slave_read(data2);
            s_in_3->slave_read(data3);

            s_out_1->slave_write(data1);
            s_out_2->slave_write(data2);
            s_out_3->slave_write(data3);
        }
    }
};
//*/

/*
/// Not having all slaves in each operation in a slave module throws an error
struct TestMasterSlave_4X : public sc_module {

    //Constructor
    SC_HAS_PROCESS(TestMasterSlave_4X);

    TestMasterSlave_4X(sc_module_name name) :
            s_in_1("s_in_1"),
            s_in_2("s_in_2"),
            s_in_3("s_in_3"),
            data1(0),
            data2(0),
            data3(0) {
        SC_THREAD(fsm);
    }

    //Out-port
    slave_in<int> s_in_1;
    slave_in<int> s_in_2;
    slave_in<int> s_in_3;

    //Vars
    int data1;
    int data2;
    int data3;

    void fsm() {
        while (true) {
            wait(WAIT_TIME, SC_PS);//state

            s_in_1->slave_read(data1);
//            s_in_2->slave_read(data2); //not having this input port used triggers an error
            s_in_3->slave_read(data3);
        }
    }
};
//*/

/*
/// Not having all slaves in each operation in a slave module throws an error
struct TestMasterSlave_5X : public sc_module {

    //Constructor
    SC_HAS_PROCESS(TestMasterSlave_5X);

    TestMasterSlave_5X(sc_module_name name) :
            s_in_1("s_in_1"),
            s_in_2("s_in_2"),
            s_in_3("s_in_3"),
            data1(0),
            data2(0),
            data3(0) {
        SC_THREAD(fsm);
    }

    //Out-port
    slave_in<int> s_in_1;
    slave_in<int> s_in_2;
    slave_in<int> s_in_3;

    //Vars
    int data1;
    int data2;
    int data3;

    void fsm() {
        while (true) {
            wait(WAIT_TIME, SC_PS);//state

            s_in_1->slave_read(data1);
            s_in_2->slave_read(data2);
            s_in_3->slave_read(data3);

            if (data3 > 5) {
                wait(WAIT_TIME, SC_PS);//state

                s_in_1->slave_read(data1);
//                s_in_2->slave_read(data2); // triggers an error
                s_in_3->slave_read(data3);
            }
        }
    }
};
//*/

/*
/// Invalid Slaves Order: missing slave port from the path!
struct TestMasterSlave_6X : public sc_module {

    //Constructor
    SC_HAS_PROCESS(TestMasterSlave_6X);

    TestMasterSlave_6X(sc_module_name name) :
            s_in_1("s_in_1"),
            s_in_2("s_in_2"),
            s_in_3("s_in_3"),
            s_out_1("s_out_1"),
            s_out_2("s_out_2"),
            s_out_3("s_out_3"),
            data1(0),
            data2(0),
            data3(0) {
        SC_THREAD(fsm);
    }

    //Out-port
    slave_in<int> s_in_1;
    slave_in<int> s_in_2;
    slave_in<int> s_in_3;
    slave_out<int> s_out_1;
    slave_out<int> s_out_2;
    slave_out<int> s_out_3;

    //Vars
    int data1;
    int data2;
    int data3;

    void fsm() {
        while (true) {
            wait(WAIT_TIME, SC_PS);

            s_in_1->slave_read(data1);
            s_in_2->slave_read(data2);
            s_in_3->slave_read(data3);

            s_out_1->slave_write(data1);
            s_out_2->slave_write(data2);
            s_out_3->slave_write(data3);

            wait(WAIT_TIME, SC_PS);//state

            s_in_2->slave_read(data1);
            s_in_2->slave_read(data2);// triggers an error
            s_in_3->slave_read(data3);

            s_out_1->slave_write(data1);
            s_out_2->slave_write(data2);
            s_out_3->slave_write(data3);
        }
    }
};
//*/

/*
/// missing slave port from the path!
struct TestMasterSlave_7X : public sc_module {

    //Constructor
    SC_HAS_PROCESS(TestMasterSlave_7X);

    TestMasterSlave_7X(sc_module_name name) :
            s_in_1("s_in_1"),
            s_in_2("s_in_2"),
            s_in_3("s_in_3"),
            data1(0),
            data2(0),
            data3(0) {
        SC_THREAD(fsm);
    }

    //Out-port
    slave_in<int> s_in_1;
    slave_in<int> s_in_2;
    slave_in<int> s_in_3;

    //Vars
    int data1;
    int data2;
    int data3;

    void fsm() {
        while (true) {
            wait(WAIT_TIME, SC_PS);//state

            s_in_1->slave_read(data1);
            s_in_3->slave_read(data2);
            s_in_3->slave_read(data3);
        }
    }
};
//*/

/*
/// missing slave port from the path!
struct TestMasterSlave_8X : public sc_module {

    //Constructor
    SC_HAS_PROCESS(TestMasterSlave_8X);

    TestMasterSlave_8X(sc_module_name name) :
            s_out_1("s_out_1"),
            s_out_2("s_out_2"),
            s_out_3("s_out_3"),
            data1(0),
            data2(0),
            data3(0) {
        SC_THREAD(fsm);
    }

    //Out-port
    slave_out<int> s_out_1;
    slave_out<int> s_out_2;
    slave_out<int> s_out_3;

    //Vars
    int data1;
    int data2;
    int data3;

    void fsm() {
        while (true) {
            wait(WAIT_TIME, SC_PS);//state

            s_out_1->slave_write(data1);
            s_out_3->slave_write(data2);
            s_out_3->slave_write(data3);
        }
    }
};
//*/

/*
/// passing an output port more than once!
/// reset property should not have any slave communications in it
struct TestMasterSlave_9X : public sc_module {

    //Constructor
    SC_HAS_PROCESS(TestMasterSlave_9X);

    TestMasterSlave_9X(sc_module_name name) :
            s_out_1("s_out_1"),
            s_out_2("s_out_2"),
            s_out_3("s_out_3"),
            data1(0),
            data2(0),
            data3(0) {
        SC_THREAD(fsm);
    }

    //Out-port
    slave_out<int> s_out_1;
    slave_out<int> s_out_2;
    slave_out<int> s_out_3;

    //Vars
    int data1;
    int data2;
    int data3;

    void fsm() {
        while (true) {
            s_out_1->slave_write(data1); // this will trigger an error
            wait(WAIT_TIME, SC_PS);//state

            s_out_1->slave_write(data1);
            s_out_2->slave_write(data2);
            s_out_3->slave_write(data3);
        }
    }
};
//*/

#endif //PROJECT_FIFO_H


