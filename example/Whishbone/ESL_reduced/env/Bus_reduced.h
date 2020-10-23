//
// Created by ludwig on 30.01.17.
//
#include <Interfaces.h>
#include "systemc.h"

enum trans_t {
    SINGLE_READ, SINGLE_WRITE
};
enum ack_t  {
    OK, RTY, ERR
};

enum addr_t {
    SLAVE0, SLAVE1, SLAVE2, SLAVE3
};

struct bus_req_t{
    addr_t addr;
    trans_t trans_type;
    bool data;
};

struct bus_resp_t{
    bool data;
    ack_t ack;
};

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
            master_in->read(req);

            if(SINGLE_READ == req.trans_type){
                req.data = false;
            }

            if  (req.addr == SLAVE0) {
                slave_out0->write(req);
                slave_in0->read(resp);
            }
            else if (req.addr == SLAVE1) {
                slave_out1->write(req);
                slave_in1->read(resp);
            }
            else if (req.addr == SLAVE2) {
                slave_out2->write(req);
                slave_in2->read(resp);
            }
            else if (req.addr == SLAVE3) {
                slave_out3->write(req);
                slave_in3->read(resp);
            }
            else {
                resp.ack = OK;
                resp.data = false;
            }
            if(SINGLE_WRITE== req.trans_type){
                resp.data = false;
            }
            master_out->write(resp);
            wait(SC_ZERO_TIME);
        }
    }
};


#endif //PROJECT_BUS_H
