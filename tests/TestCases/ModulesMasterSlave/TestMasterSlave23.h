//
// Created by hesselberg on 9/30/20.
//

#ifndef SCAM_TESTMASTERSLAVE23_H
#define SCAM_TESTMASTERSLAVE23_H

#include "systemc.h"
#include "Interfaces.h"
#include "../Types.h"

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
#endif //SCAM_TESTMASTERSLAVE23_H
