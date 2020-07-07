//
// Created by ludwig on 30.01.17.
//
#include "../../Interfaces/Interfaces.h"
#include "systemc.h"

#include "../../SingleMasterMultiSlave/ESL/Compound.h" // several tests run only when this header is not specified in bus.h
//#include "../../../tests/Print_ITL_Tests/TestCases/to_delete/Types.h"

#ifndef PROJECT_BUS_H
#define PROJECT_BUS_H

struct Bus : public sc_module {

    //In-port
    blocking_in<bus_req_t> master_in;
    blocking_in<bus_resp_t> slave_in0;
    blocking_in<bus_resp_t> slave_in1;
    blocking_in<bus_resp_t> slave_in2;
    blocking_in<bus_resp_t> slave_in3;

    //Out-por
    blocking_out<bus_resp_t> master_out;
    blocking_out<bus_req_t> slave_out0;
    blocking_out<bus_req_t> slave_out1;
    blocking_out<bus_req_t> slave_out2;
    blocking_out<bus_req_t> slave_out3;

    //Variables
    bus_req_t req;
    bus_resp_t resp;

    int foo;

    //Constructor
    SC_HAS_PROCESS(Bus);

    Bus(sc_module_name name) :
            master_in("master_in"),
            master_out("master_out"),
            slave_out0("slave_out0"),
            slave_out1("slave_out1"),
            slave_out2("slave_out2"),
            slave_out3("slave_out3"),
            slave_in0("slave_in0"),
            slave_in1("slave_in1"),
            slave_in2("slave_in2"),
            slave_in3("slave_in3") {
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
            master_in->read(req,"master_in");

            if(SINGLE_READ == req.trans_type){
                req.data = 0;
            }

            if  (req.addr >= 0 && req.addr < 8) {
                slave_out0->write(req,"slave_out0");
                slave_in0->read(resp,"slave_in0");
            }

            else if (req.addr >= 8 && req.addr < 16) {
                req.addr = req.addr - 8;
                slave_out1->write(req,"slave_out1");
                slave_in1->read(resp,"slave_in1");
            }
            else if (req.addr >= 16 && req.addr < 24) {
                req.addr = req.addr - 16;
                slave_out2->write(req,"slave_out2");
                slave_in2->read(resp,"slave_in2");
            }
            else if (req.addr >= 24 && req.addr < 32) {
                req.addr = req.addr - 24;
                slave_out3->write(req,"slave_out3");
                slave_in3->read(resp,"slave_in3");
            }
            else {
//                resp.ack = OK;
//                resp.data = 0;
            }
            if(SINGLE_WRITE== req.trans_type){
                resp.data = 0;
            }
            master_out->write(resp,"master_out");

            //wait(SC_ZERO_TIME);
        }
    }
};


#endif //PROJECT_BUS_H
