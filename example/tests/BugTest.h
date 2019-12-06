//
// Created by ludwig on 10.10.17.
//

#ifndef PROJECT_SLAVEDAVEBAVE2_H_H
#define PROJECT_SLAVEDAVEBAVE2_H_H


#include "systemc.h"
#include "../Interfaces/Interfaces.h"


// register file output interface
//
//struct TestArray02 : public sc_module {
//    blocking_in<int> b_in;
//    blocking_out<int> b_out;
//    //Constructor
//    SC_HAS_PROCESS(TestArray02);
//
//    TestArray02(sc_module_name name) :
//            b_in("m_in"),
//            b_out("m_out"),
//            test(2){
//        SC_THREAD(fsm);
//    }
//
//    int test;
//    int myArray[5];
//
//    void fsm() {
//        while (true) {
//            b_in->read(test);
//            test = test;
//            myArray[0] = myArray[test];
//            b_out->write(myArray[0]);
//        }
//    }
//};


struct test{
    int x;
    int y;
};

struct Bus_new : public sc_module {

    //In-port
    blocking_in<test> master_in;
    blocking_in<test> slave_in0;
    blocking_in<int> slave_in1;
    blocking_in<int> slave_in2;
    blocking_in<int> slave_in3;


    //Out-por
    blocking_out<test> master_out;
    blocking_out<test>slave_out0;
    blocking_out<int> slave_out1;
    blocking_out<int> slave_out2;
    blocking_out<int> slave_out3;


    //Variables
    test req;
    test resp;

    //Constructor
    SC_HAS_PROCESS(Bus_new);

    Bus_new(sc_module_name name) :
            master_in("master_in"),
            master_out("master_out"),
            slave_out0("slave_out0"),
//            slave_out1("slave_out1"),
//            slave_out2("slave_out2"),
//            slave_out3("slave_out3"),
            slave_in0("slave_in0")
//            slave_in1("slave_in1"),
//            slave_in2("slave_in2"),
//            slave_in3("slave_in3")
    {
        SC_THREAD(fsm);
    }


    void fsm() {

        while (true) {
            /*
            0 - 7  HEAT
            8 - 15 MIX
            16 - 23 TEMP_TOP
            24 - 31 TEMP_BOT
             */
            master_in->read(req);
//            std::cout << "req addrs:" << req.addr << std::endl;
//            std::cout << "req data:" << req.data << std::endl;
//            std::cout << "req mode:" << req.trans_type << std::endl;

//            if(SINGLE_READ == req.trans_type){
//                req.data = 0;
//            }

//            if  (req.addr >= 0 && req.addr < 8) {
            slave_out0->write(req);
            slave_in0->read(resp);
//            }
//            else if (req.addr >= 8 && req.addr < 16) {
//                req.addr = req.addr - 8;
//                slave_out1->write(req);
//                slave_in1->read(resp);
//            }
//            else if (req.addr >= 16 && req.addr < 24) {
//                req.addr = req.addr - 16;
//                slave_out2->write(req);
//                slave_in2->read(resp);
//            }
//            else if (req.addr >= 24 && req.addr < 32) {
//                req.addr = req.addr - 24;
//                slave_out3->write(req);
//                slave_in3->read(resp);
//            }
//            else {
//                resp.ack = OK;
//                resp.data = 0;
//            }
//            if(SINGLE_WRITE== req.trans_type){
//                resp.data = 0;
//            }
            master_out->write(resp);
            //wait(SC_ZERO_TIME);
        }
    }
};


//struct TestArrayX : public sc_module {
//    //Sections
//    enum Sections {
//        SECTION_A, SECTION_B
//    };
//
//    Sections section;
//    Sections nextsection;
//
//    //Constructor
//    SC_HAS_PROCESS(TestArrayX);
//
//    TestArrayX(sc_module_name name) :
//            b_out("b_out"),
//            section(SECTION_A),
//            nextsection(SECTION_A) {
//        SC_THREAD(fsm);
//    }
//
//    //Out-port
//    master_in<unsigned[4]> m_in;
//    blocking_out<unsigned> b_out;
//
//    unsigned tmp[4];
//
//    unsigned foobar(unsigned num) const{
//        return num;
//    }
//
//    void fsm() {
//        while (true) {
//            m_in->master_read(tmp);
//            b_out->write(tmp[foobar(0)]);
//        }
//    }
//};


#endif //PROJECT_SLAVEDAVEBAVE_H_H
