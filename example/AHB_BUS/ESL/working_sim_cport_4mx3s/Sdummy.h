//
// Created by ovsthus on 11/15/19.
//

#ifndef ABSTRACT_BUS_SDUMMY_H
#define ABSTRACT_BUS_SDUMMY_H

#include "compound.h"
#include "systemc.h"
#include "Interfaces.h"

struct Sdummy : public sc_module{


    blocking_in<ahb_to_slv> bus_in;
    blocking_out<slv_to_mst> bus_out;

    ahb_to_slv bus_req;
    slv_to_mst bus_resp;

    //Constructor
    SC_HAS_PROCESS(Sdummy);

    Sdummy(sc_module_name name) :
            bus_in("bus_in"),
            bus_out("bus_out")
    {
        SC_THREAD(fsm);
    }

    int randerr;



    void fsm() {

bus_resp.hresp = 0;


        while(true) {

randerr = std::rand()%30 + 1;

            bus_in->read(bus_req);

            std::cout << this->name() << " receives: " << bus_req.hwdata << " to addr: " << bus_req.haddr << std::endl;

            bus_resp.hrdata = bus_req.hwdata;


            bus_out->write(bus_resp);

            std::cout << this->name() << " returned: " << bus_resp.hrdata << " with err code: " << bus_resp.hresp << std::endl;

            if(randerr % 5 == 0){
                bus_resp.hresp = 1;
            }else{
                bus_resp.hresp = 0;
            }

        }

    }

};

#endif //ABSTRACT_BUS_SDUMMY_H
