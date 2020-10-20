//
// Created by hesselberg on 9/30/20.
//

#ifndef SCAM_TESTMASTERSLAVE20_H
#define SCAM_TESTMASTERSLAVE20_H

#include "systemc.h"
#include "Interfaces.h"
#include "../Types.h"

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
#endif //SCAM_TESTMASTERSLAVE20_H
