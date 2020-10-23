//
// Created by hesselberg on 9/30/20.
//

#ifndef SCAM_TESTMASTERSLAVE15_H
#define SCAM_TESTMASTERSLAVE15_H

#include "systemc.h"
#include "Interfaces.h"
#include "../Types.h"

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
#endif //SCAM_TESTMASTERSLAVE15_H
