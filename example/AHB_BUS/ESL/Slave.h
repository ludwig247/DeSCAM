//
// Created by wezel on 8/11/20.
//

#ifndef DESCAM_SLAVE_H
#define DESCAM_SLAVE_H

#include "types.h"
#include "systemc.h"
#include "AHB_Bus_Channel.h"
#include "Interfaces.h"

SC_MODULE(Slave){
    sc_port<AHB_Bus_Channel_Slave_out_if> slave_out;
    sc_port<AHB_Bus_Channel_Slave_in_if> slave_in;

    int id;
    bus_req_t bus_req;
    bus_resp_t bus_resp;

    void drive_out(){
        static int number_of_slaves;
        id = number_of_slaves;
        number_of_slaves++;
        while(true) {
            slave_in->read_slave(bus_req,id);
            bus_resp.hrdata = bus_req.hwdata;
            bus_resp.hresp = ok_resp;
            slave_out->write_slave(bus_resp,id);
        }
    }

    SC_CTOR(Slave){
        SC_THREAD(drive_out);
    }
};


#endif //DESCAM_SLAVE_H
