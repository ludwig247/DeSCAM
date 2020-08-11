//
// Created by ovsthus on 11/15/19.
//

#ifndef ABSTRACT_BUS_SDUMMY_H
#define ABSTRACT_BUS_SDUMMY_H

#include "types.h"
#include "systemc.h"
#include "Interfaces.h"

struct Sdummy : public sc_module {
    blocking_in<bus_req_t> slave_in;
    blocking_out<bus_resp_t> slave_out;

    //Constructor
    SC_HAS_PROCESS(Sdummy);

    Sdummy(sc_module_name name) :
            slave_in("slave_in"),
            slave_out("slave_out") {
        SC_THREAD(fsm);
    }

    bus_req_t req;
    bus_resp_t resp;

    void fsm() {
        while (true) {
            slave_in->read(req);
            resp.hrdata = req.hwdata;
            resp.hresp = ok_resp;
            slave_out->write(resp);
        }
    }
};

#endif //ABSTRACT_BUS_SDUMMY_H
