//
// Created by hesselberg on 9/30/20.
//

#ifndef SCAM_TESTBASIC26_H
#define SCAM_TESTBASIC26_H

#include "systemc.h"
#include "Interfaces.h"
#include "../Types.h"

struct TestBasic26 : public sc_module {

    //Constructor
    SC_HAS_PROCESS(TestBasic26);

    TestBasic26(sc_module_name name) :
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

            m_out_1->master_write(data1);
            m_out_2->master_write(data2);
            m_out_3->master_write(data3);//state_11
        }
    }
};

#endif //SCAM_TESTBASIC26_H
