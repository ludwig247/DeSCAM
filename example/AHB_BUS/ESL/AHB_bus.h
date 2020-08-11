//
// Created by tobias on 17.01.20.
//

#ifndef OPERATION_PIPELINE_TEST_H
#define OPERATION_PIPELINE_TEST_H

#include "systemc.h"
#include "Interfaces.h"
#include "types.h"

SC_MODULE(AHB) {
    SC_CTOR(AHB) {
        SC_THREAD(fsm);
    }

    blocking_in<bus_req_t> master0_in;
    blocking_in<bus_req_t> master1_in;
    blocking_in<bus_req_t> master2_in;
    blocking_in<bus_req_t> master3_in;

    blocking_out<bus_resp_t> master0_out;
    blocking_out<bus_resp_t> master1_out;
    blocking_out<bus_resp_t> master2_out;
    blocking_out<bus_resp_t> master3_out;

    blocking_out<bus_req_t> slave0_out;
    //blocking_out<bus_req_t> slave1_out;
    //blocking_out<bus_req_t> slave2_out;
    //blocking_out<bus_req_t> slave3_out;

    blocking_in<bus_resp_t> slave0_in;
    //blocking_in<bus_resp_t> slave1_in;
    //blocking_in<bus_resp_t> slave2_in;
    //blocking_in<bus_resp_t> slave3_in;

    bus_req_t req;
    bus_resp_t resp;
    bool toIdle;

    unsigned int fromMaster;
    unsigned int toSlave;

    void fsm() {
        fromMaster = -1;
        while (true) {
            insert_state("idle");
            if (master3_in->peek()) {
                fromMaster = 3;
                master3_in->read(req, "master3_in");
                toIdle = false;
            } else if (master2_in->peek()) {
                fromMaster = 2;
                master2_in->read(req, "master2_in");
                toIdle = false;
            } else if (master1_in->peek()) {
                fromMaster = 1;
                master1_in->read(req, "master1_in");
                toIdle = false;
            } else if (master0_in->peek()) {
                fromMaster = 0;
                master0_in->read(req, "master0_in");
                toIdle = false;
            } else {
                fromMaster = -1;
                //Read from master with highest priority
                toIdle = true;
            }

            if (!toIdle) {
                slave0_out->write(req, "slave0_out");
                slave0_in->read(resp, "slave0_in");
                if (fromMaster == 3) {
                    master3_out->write(resp, "master3_out");
                } else if (fromMaster == 2) {
                    master2_out->write(resp, "master2_out");
                } else if (fromMaster == 1) {
                    master1_out->write(resp, "master1_out");
                } else if (fromMaster == 0) {
                    master0_out->write(resp, "master0_out");
                }
            }
        }
    }

};


#endif //OPERATION_PIPELINE_TEST_H
