//
// Created by wezel on 8/11/20.
//

#ifndef DESCAM_MASTER_H
#define DESCAM_MASTER_H

#include "types.h"
#include "systemc.h"
#include "AHB_Bus_Channel.h"

SC_MODULE(Master){
    sc_port<AHB_Bus_Channel_Master_out_if> master_out;
    sc_port<AHB_Bus_Channel_Master_in_if> master_in;

    int id;
    bus_req_t bus_req;
    bus_resp_t bus_resp;

    void drive_out(){
        static int number_of_masters;
        id = number_of_masters;
        number_of_masters++;
        bus_req.hwrite = AHB_WRITE;
        bus_req.hsize = MT_W;
        while(true) {
            bus_req.haddr = static_cast<unsigned int>(std::rand() % 0x00040000);
            bus_req.hwdata = static_cast<unsigned int>(std::rand() % 10000 + 1);
            //Produce Values and write them to the Input of the FIFO
            std::cout << "At " << sc_time_stamp() <<" "<< this->name() << " tries to write : " << bus_req.hwdata << " to addr: " << bus_req.haddr << std::endl;
            master_out->write_master(bus_req, id);
            std::cout << "At " << sc_time_stamp() <<" "<< this->name() << " wrote: " << bus_req.hwdata << " to addr: " << bus_req.haddr << std::endl;

            std::cout << "At " << sc_time_stamp() <<" "<< this->name() << " tries to read : " << std::endl;
            master_in->read_master(bus_resp,id);
            std::cout << "At " << sc_time_stamp() <<" "<< this->name() << " received back: " << bus_resp.hrdata << " with err code: " << bus_resp.hresp << std::endl;
            if(bus_resp.hresp == ok_resp) {
                assert(bus_resp.hrdata == bus_req.hwdata && "Response has returned to the wrong master!");
            }

            if(std::rand()%2 == 0) insert_state();
        }
    }

    SC_CTOR(Master){
        SC_THREAD(drive_out);
    }
};
#endif //DESCAM_MASTER_H
