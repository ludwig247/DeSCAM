//
// Created by hesselberg on 9/30/20.
//

#ifndef SCAM_TESTBASIC27_H
#define SCAM_TESTBASIC27_H

#include "systemc.h"
#include "Interfaces.h"
#include "../Types.h"

struct TestBasic27 : public sc_module {

    //Constructor
    SC_HAS_PROCESS(TestBasic27);

    TestBasic27(sc_module_name name) :
            m_in_1("m_in_1"),
            m_in_2("m_in_2"),
            m_in_3("m_in_3"),
            m_out_1("m_out_1"),
            m_out_2("m_out_2"),
            m_out_3("m_out_3"),
            data1(0),
            data2(0),
            data3(0) {
        SC_THREAD(fsm);
    }

    //Out-port
    master_in<int> m_in_1;
    master_in<int> m_in_2;
    master_in<int> m_in_3;
    master_out<int> m_out_1;
    master_out<int> m_out_2;
    master_out<int> m_out_3;

    //Vars
    int data1;
    int data2;
    int data3;

    void fsm() {
        while (true) {
            m_in_1->master_read(data1);
            m_in_2->master_read(data2);
            m_in_3->master_read(data3);

            m_in_1->master_read(data1);//state_9

            m_out_1->master_write(data1);
            m_out_2->master_write(data2);
            m_out_3->master_write(data3);//state_12
        }
    }
};

#endif //SCAM_TESTBASIC27_H
