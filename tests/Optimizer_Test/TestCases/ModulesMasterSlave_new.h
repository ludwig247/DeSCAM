//
// Created by ludwig on 07.06.17.
//

#ifndef PROJECT_MODULES_MS_H
#define PROJECT_MODULES_MS_H

#include "systemc.h"
#include "../../../example/Interfaces/Interfaces.h"
//#include "Interfaces.h"
#include "Types.h"

///*
struct TestMasterSlave00 : public sc_module {
    //Sections
    enum Phases { SECTION_A, SECTION_B};
    Phases phase, nextphase;

    //Constructor
    SC_HAS_PROCESS(TestMasterSlave00);

    TestMasterSlave00(sc_module_name name) :
            s_in("s_in") {
        SC_THREAD(fsm);
    }
    //Out-port
    slave_in<int> s_in;

    //Variable
    int val;

    void fsm() {
        nextphase = SECTION_A;
        while (true) {
            phase = nextphase;
            if (phase == SECTION_A) {
                wait(WAIT_TIME, SC_PS);//state
                s_in->slave_read(val);
                nextphase = SECTION_B;
            }
            if (phase == SECTION_B) {
                nextphase = SECTION_A;
            }
        }
    }
};
//*/

///*
struct TestMasterSlave01 : public sc_module {
    //Sections
    enum Phases { SECTION_A, SECTION_B};
    Phases phase, nextphase;

    //Constructor
    SC_HAS_PROCESS(TestMasterSlave01);

    TestMasterSlave01(sc_module_name name) :
            s_out("s_out") {
        SC_THREAD(fsm);
    }
    //Out-port
    slave_out<int> s_out;

    //Variable
    int val;

    void fsm() {
        nextphase = SECTION_A;
        while (true) {
            phase = nextphase;
            if (phase == SECTION_A) {
                wait(WAIT_TIME, SC_PS);//state //Remark: slave_out_sig will be assignment in reset property the defualt value
                s_out->slave_write(1337);
                nextphase = SECTION_B;
            }
            if (phase == SECTION_B) {
                nextphase = SECTION_A;
            }
        }
    }
};
//*/

///*
struct TestMasterSlave03 : public sc_module {
    //Sections
    enum Phases { SECTION_A, SECTION_B};
    Phases phase, nextphase;

    //Constructor
    SC_HAS_PROCESS(TestMasterSlave03);

    TestMasterSlave03(sc_module_name name) :
            s_out("s_out"),
            s_in("s_in"),
            val(1337){
        SC_THREAD(fsm);
    }
    //Out-port
    slave_out<int> s_out;
    slave_in<int> s_in;

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
                nextphase = SECTION_B;
            }
            if (phase == SECTION_B) {
                nextphase = SECTION_A;
            }
        }
    }
};
//*/

///*
struct TestMasterSlave04 : public sc_module {
    //Sections
    enum Phases { SECTION_A, SECTION_B};
    Phases phase, nextphase;

    //Constructor
    SC_HAS_PROCESS(TestMasterSlave04);

    TestMasterSlave04(sc_module_name name) :
            s_in2("s_in2"),
            s_in("s_in"),
            val(1337){
        SC_THREAD(fsm);
    }
    //Out-port
    slave_in<int> s_in2;
    slave_in<int> s_in;

    //Variable
    int val;

    void fsm() {
        nextphase = SECTION_A;
        while (true) {
            phase = nextphase;
            if (phase == SECTION_A) {
                wait(WAIT_TIME, SC_PS);//state
                s_in->slave_read(val);
                s_in2->slave_read(val);
                nextphase = SECTION_B;
            }
            if (phase == SECTION_B) {
                nextphase = SECTION_A;
            }
        }
    }
};
//*/

///*
struct TestMasterSlave06 : public sc_module {
    //Sections
    enum Phases { SECTION_A, SECTION_B};
    Phases phase, nextphase;

    //Constructor
    SC_HAS_PROCESS(TestMasterSlave06);

    TestMasterSlave06(sc_module_name name):
            s_in("s_in") {
        SC_THREAD(fsm);
    }
    //Out-port
    slave_in<int> s_in;

    //Variable
    int val;

    void fsm() {
        nextphase = SECTION_A;
        while (true) {
            phase = nextphase;
            if (phase == SECTION_A) {
                wait(WAIT_TIME, SC_PS);//state
                s_in->slave_read(val);
                wait(WAIT_TIME, SC_PS);//state
                s_in->slave_read(val);
                nextphase = SECTION_B;
            }
            if (phase == SECTION_B) {
                wait(WAIT_TIME, SC_PS);//state
                s_in->slave_read(val);
                nextphase = SECTION_A;
            }
        }
    }
};
//*/

///*
struct TestMasterSlave07 : public sc_module {
    //Sections
    enum Phases { SECTION_A, SECTION_B};
    Phases phase, nextphase;

    //Constructor
    SC_HAS_PROCESS(TestMasterSlave07);

    TestMasterSlave07(sc_module_name name) :
            s_in("s_in"),
            s_out("s_out") {
        SC_THREAD(fsm);
    }

    //Out-port
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
                nextphase = SECTION_B;
            }
            if (phase == SECTION_B) {
                wait(WAIT_TIME, SC_PS);//state
                s_in->slave_read(val);
                ++val;
                s_out->slave_write(val);
                nextphase = SECTION_A;
            }
        }
    }
};
//*/

///*
struct TestMasterSlave08 : public sc_module {
    //Sections
    enum Phases { SECTION_A, SECTION_B};
    Phases phase, nextphase;

    //Constructor
    SC_HAS_PROCESS(TestMasterSlave08);

    TestMasterSlave08(sc_module_name name) :
            s_in("s_in"),
            s_out("s_out") {
        SC_THREAD(fsm);
    }

    //Out-port
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
                if(val > 10)  nextphase = SECTION_B;
            }
            if (phase == SECTION_B) {
                wait(WAIT_TIME, SC_PS);//state
                s_in->slave_read(val);
                ++val;
                s_out->slave_write(val);
                nextphase = SECTION_A;
            }
        }
    }
};
//*/

///*
struct TestMasterSlave09 : public sc_module {
    //Sections
    enum Phases { SECTION_A, SECTION_B};
    Phases phase, nextphase;

    //Constructor
    SC_HAS_PROCESS(TestMasterSlave09);

    TestMasterSlave09(sc_module_name name) :
            s_in("s_in"),
            sh_out("sh_out") {
        SC_THREAD(fsm);
    }

    //Out-port
    slave_in<int> s_in;
    shared_out <int> sh_out;

    //Variable
    int val;

    void fsm() {
        nextphase = SECTION_A;
        while (true) {
            phase = nextphase;
            if (phase == SECTION_A) {
                sh_out->set(val);
                wait(WAIT_TIME, SC_PS);//state //Remark: it differs! having the wait statement before of the shared output or after
                s_in->slave_read(val);
                nextphase = SECTION_B;
            }
            if (phase == SECTION_B) {
                nextphase = SECTION_A;
            }
        }
    }
};
//*/

///*
struct TestMasterSlave10 : public sc_module {
    //Sections
    enum Phases { SECTION_A, SECTION_B};
    Phases phase, nextphase;

    //Constructor
    SC_HAS_PROCESS(TestMasterSlave10);

    TestMasterSlave10(sc_module_name name) :
            s_in("s_in"),
            s_in2("s_in2"),
            sh_out("sh_out"),
            sh_in("sh_in") {
        SC_THREAD(fsm);
    }

    //Out-port
    slave_in<int> s_in;
    slave_in<int> s_in2;
    shared_in<int> sh_in;
    shared_out <int> sh_out;

    //Variable
    int val;
    int shared;
    bool succ;

    void fsm() {
        nextphase = SECTION_A;
        while (true) {
            phase = nextphase;
            if (phase == SECTION_A) {
                wait(WAIT_TIME, SC_PS);//state
                s_in->slave_read(val);
                s_in2->slave_read(val);
                sh_out->set(val);
                if(succ) nextphase = SECTION_B;//FIXME:: this should be unreachable
                                          // but because the backtrack only goes until the while(true) statement, then we can't exclude it
                                            // Ibra's work should detect it.
            }
            if (phase == SECTION_B) {
                wait(WAIT_TIME, SC_PS);
                s_in->slave_read(val); //FIXME: original properties are not as expected!
                s_in2->slave_read(val);
                val = val*2;
                sh_in->get(shared);//FIXME: this variable should disappear because we always read from sh_in
                sh_out->set(val*2 + shared);
                nextphase = SECTION_A;
            }
        }
    }
};
//*/

///*
struct TestMasterSlave11 : public sc_module {
    //Sections
    enum Phases { SECTION_A, SECTION_B};
    Phases phase, nextphase;

    //Constructor
    SC_HAS_PROCESS(TestMasterSlave11);

    TestMasterSlave11(sc_module_name name) :
            s_in("s_in"),
            sh_out("sh_out"),
            sh_in("sh_in") {
        SC_THREAD(fsm);
    }

    //Out-port
    slave_in<int> s_in;
    shared_out <int> sh_out;
    shared_in <bool> sh_in;

    //Variable
    int val;
    bool succ;

    void fsm() {
        nextphase = SECTION_A;
        while (true) {
            phase = nextphase;
            if (phase == SECTION_A) {
                wait(WAIT_TIME, SC_PS);//state
                s_in->slave_read(val);
                sh_out->set(val);
                sh_in->get(succ);
                if(succ) nextphase = SECTION_B;
            }
            if (phase == SECTION_B) {
                wait(WAIT_TIME, SC_PS);//state
                s_in->slave_read(val);
                val = val*2;
                sh_out->set(val);
                nextphase = SECTION_A;
            }
        }
    }
};
//*/

///*
struct TestMasterSlave12 : public sc_module {
    //Sections
    enum Phases { SECTION_A, SECTION_B};
    Phases phase, nextphase;

    //Constructor
    SC_HAS_PROCESS(TestMasterSlave12);

    TestMasterSlave12(sc_module_name name) :
            s_in("s_in"),
            s_in2("s_in2"),
            sh_out("sh_out") {
        SC_THREAD(fsm);
    }

    //Out-port
    slave_in<int> s_in;
    slave_in<int> s_in2;
    shared_out <int> sh_out;

    //Variable
    int val;
    bool succ;

    void fsm() {
        nextphase = SECTION_A;
        while (true) {
            phase = nextphase;
            if (phase == SECTION_A) {
                wait(WAIT_TIME, SC_PS);//state
                s_in->slave_read(val);
                s_in2->slave_read(val);
                sh_out->set(val);
                if(succ) nextphase = SECTION_B;
            }
            if (phase == SECTION_B) {
                wait(WAIT_TIME, SC_PS);//state
                s_in->slave_read(val);
                s_in2->slave_read(val);
                val = val*2;
                sh_out->set(val*2);
                nextphase = SECTION_A;
            }
        }
    }
};
//*/

///*
struct TestMasterSlave13 : public sc_module {
    //Sections
    enum Phases { SECTION_A, SECTION_B};
    Phases phase, nextphase;

    //Constructor
    SC_HAS_PROCESS(TestMasterSlave13);

    TestMasterSlave13(sc_module_name name) :
            s_in("s_in"),
            s_in2("s_in2"),
            sh_out("sh_out"),
            m_in("m_in"),
            m_out("m_out"),
            sh_out2("sh_out2") {
        SC_THREAD(fsm);
    }

    //Out-port
    slave_in<int> s_in;
    slave_in<int> s_in2;
    shared_out <int> sh_out;
    master_in<int> m_in;
    master_out<int> m_out;
    shared_out<int> sh_out2;


    //Variable
    int val;
    int save_val;
    bool succ;

    void fsm() {
        nextphase = SECTION_A;
        while (true) {
            phase = nextphase;
            if (phase == SECTION_A) {
                wait(WAIT_TIME, SC_PS);//state
                s_in->slave_read(val);
                save_val += val;
                m_in->master_read(val);
                save_val += val;
                s_in2->slave_read(val);
                save_val += val;
                m_out->master_write(save_val);
                sh_out2->set(save_val);
                sh_out->set(val);
                if(succ) nextphase = SECTION_B;
            }
            if (phase == SECTION_B) {
                wait(WAIT_TIME, SC_PS);//state
                s_in->slave_read(val);
                s_in2->slave_read(val);
                val = val*2;
                sh_out->set(val*2);
                nextphase = SECTION_A;
            }
        }
    }
};
//*/

///*
struct TestMasterSlave17 : public sc_module {

    //Constructor
    SC_HAS_PROCESS(TestMasterSlave17);

    TestMasterSlave17(sc_module_name name) :
            s_out_1("s_out_1"),
            s_out_2("s_out_2"),
            s_out_3("s_out_3") {
        SC_THREAD(fsm);
    }

    //Out-port
    slave_out<bus_req_t> s_out_1;
    slave_out<bus_req_t> s_out_2;
    slave_out<bus_req_t> s_out_3;

    //Vars
    bus_req_t data1;
    bus_req_t data2;
    bus_req_t data3;

    void fsm() {
        while (true) {
            wait(WAIT_TIME, SC_PS);//state
            data1.addr = 1;
            data2.addr = 2;
            data3.addr = 3;
            s_out_1->slave_write(data1);
            s_out_2->slave_write(data2);
            s_out_3->slave_write(data3);
        }
    }
};
//*/

///*
struct TestMasterSlave18 : public sc_module {

    //Constructor
    SC_HAS_PROCESS(TestMasterSlave18);

    TestMasterSlave18(sc_module_name name) :
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
            s_out_2->slave_write(data2);
            s_out_3->slave_write(data3);
        }
    }
};
//*/

///*
struct TestMasterSlave19 : public sc_module {

    //Constructor
    SC_HAS_PROCESS(TestMasterSlave19);

    TestMasterSlave19(sc_module_name name) :
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
        }
    }
};
//*/

///*
struct TestMasterSlave20 : public sc_module {

    //Constructor
    SC_HAS_PROCESS(TestMasterSlave20);

    TestMasterSlave20(sc_module_name name) :
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

            wait(WAIT_TIME, SC_PS);//state
            s_in_1->slave_read(data1);
            s_in_2->slave_read(data2);
            s_in_3->slave_read(data3);

            s_out_1->slave_write(data1+1);
            s_out_2->slave_write(data2+1);
            s_out_3->slave_write(data3+1);
        }
    }
};
//*/

///*
struct TestMasterSlave21 : public sc_module {

    //Constructor
    SC_HAS_PROCESS(TestMasterSlave21);

    TestMasterSlave21(sc_module_name name) :
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
        }
    }
};
//*/

///*
struct TestMasterSlave22 : public sc_module {

    //Constructor
    SC_HAS_PROCESS(TestMasterSlave22);

    TestMasterSlave22(sc_module_name name) :
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

            wait(WAIT_TIME, SC_PS);//state
            s_in_1->slave_read(data1);
            s_in_2->slave_read(data2);
            s_in_3->slave_read(data3);
        }
    }
};
//*/

///*
struct TestMasterSlave23 : public sc_module {

    //Constructor
    SC_HAS_PROCESS(TestMasterSlave23);

    TestMasterSlave23(sc_module_name name) :
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
                s_in_2->slave_read(data2);
                s_in_3->slave_read(data3);
            }
        }
    }
};
//*/

///*
struct TestMasterSlave24 : public sc_module {

    //Constructor
    SC_HAS_PROCESS(TestMasterSlave24);

    TestMasterSlave24(sc_module_name name) :
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

            if (data3 > 5) {
                wait(WAIT_TIME, SC_PS);//state
                s_in_1->slave_read(data1);
                s_in_2->slave_read(data2);
                s_in_3->slave_read(data3);

                s_out_1->slave_write(data1+1);
                s_out_2->slave_write(data2+1);
                s_out_3->slave_write(data3+1);
            }
        }
    }
};
//*/
#endif //PROJECT_FIFO_H


