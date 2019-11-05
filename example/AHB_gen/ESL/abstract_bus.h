//
// Created by ovsthus on 19.08.19.
//



#ifndef ABSTRACT_BUS_ABSTRACT_BUS_H
#define ABSTRACT_BUS_ABSTRACT_BUS_H

#include "Interfaces.h"
#include "compound.h"


struct Bus : public sc_module {

    //In-port
    blocking_in<bus_req_t> master_in;
    blocking_in<bus_resp_t> slave_in0;
    blocking_in<bus_resp_t> slave_in1;
    blocking_in<bus_resp_t> slave_in2;



    //Out-por
    blocking_out<bus_resp_t> master_out;
    blocking_out<bus_req_t> slave_out0;
    blocking_out<bus_req_t> slave_out1;
    blocking_out<bus_req_t> slave_out2;



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

            slave_in0("slave_in0"),
            slave_in1("slave_in1"),
            slave_in2("slave_in2"){
        SC_THREAD(fsm);
    }

    void fsm() {

        while (true) {

            master_in->read(req);

            if(req.hwrite == AHB_READ) {
                req.hwdata = 0;
            }

            if  (req.haddr >= slave0_start && req.haddr < slave0_end) {
                slave_out0->write(req);
                slave_in0->read(resp);

            }
            else if (req.haddr >= slave1_start && req.haddr < slave1_end) {
                req.haddr = req.haddr - slave1_start;
                slave_out1->write(req);
                slave_in1->read(resp);

            }
            else if (req.haddr >= slave2_start && req.haddr < slave2_end) {
                req.haddr = req.haddr - slave2_start;
                slave_out2->write(req);
                slave_in2->read(resp);
            }
            else {
                resp.hrdata = 0;
                resp.hresp = 1;
            }

             if(req.hwrite == AHB_WRITE){
                 resp.hrdata = 0;
             }

                master_out->write(resp);



            wait(SC_ZERO_TIME);
        }
    }
};



#endif //ABSTRACT_BUS_ABSTRACT_BUS_H
