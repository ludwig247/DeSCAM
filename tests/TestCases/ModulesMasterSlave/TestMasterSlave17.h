//
// Created by hesselberg on 9/30/20.
//

#ifndef SCAM_TESTMASTERSLAVE14_H
#define SCAM_TESTMASTERSLAVE14_H

#include "systemc.h"
#include "Interfaces.h"
#include "../Types.h"

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

#endif //SCAM_TESTMASTERSLAVE14_H
