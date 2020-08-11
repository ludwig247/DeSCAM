//
// Created by ovsthus on 11/15/19.
//

#ifndef ABSTRACT_BUS_MDUMMY_H
#define ABSTRACT_BUS_MDUMMY_H

#include "types.h"
#include "systemc.h"
#include "Interfaces.h"
#include <string.h>

struct Mdummy : public sc_module{



    blocking_out<bus_req_t> master_out;
    blocking_in<bus_resp_t> master_in;

    bus_req_t bus_req;
    bus_resp_t bus_resp;

    //Constructor
    SC_HAS_PROCESS(Mdummy);

    Mdummy(sc_module_name name) :
    master_in("master_in"),
    master_out("master_out")
    {
        SC_THREAD(fsm);
    }

    int cnt = 0;


    void fsm() {
        bus_req.hwrite = AHB_WRITE;
        bus_req.hsize = MT_W;
        while(true) {
            bus_req.haddr = static_cast<unsigned int>(std::rand() % 0xa0000);
            bus_req.hwdata = static_cast<unsigned int>(std::rand() % 10000 + 1);

            master_out->write(bus_req);

            std::cout << this->name() << " wrote: " << bus_req.hwdata << " to addr: " << bus_req.haddr << std::endl;

            master_in->read(bus_resp);

            std::cout << this->name() << " received back: " << bus_resp.hrdata << " with err code: " << bus_resp.hresp << std::endl;
            if(bus_resp.hresp == ok_resp) {
                assert(bus_resp.hrdata == bus_req.hwdata && "Response has returned to the wrong master!");
            }

            if(std::rand()%2 == 0) insert_state();
        }

    }

};



#endif //ABSTRACT_BUS_MDUMMY_H
