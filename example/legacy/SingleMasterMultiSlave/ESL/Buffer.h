//
// Created by tobias on 02.02.17.
//
#include "systemc.h"
#include "Compound.h"
#include "../../Interfaces/Interfaces.h"
#ifndef PROJECT_BUFFER_H
#define PROJECT_BUFFER_H

struct Buffer : public sc_module {
public:
    //In-port
    shared_in <int> value_in;
    //Out-port
    blocking_in <bus_req_t> bus_req;
    blocking_out <bus_resp_t> bus_resp;


    //Variables
    bus_resp_t resp;
    bus_req_t req;
    bool nb_result;
    //Constructor
    SC_HAS_PROCESS(Buffer);

    Buffer(sc_module_name name) :
            value_in("value_in"),
            bus_req("bus_req"),
            bus_resp("bus_resp"){
        SC_THREAD(fsm);
    }


    void fsm() {

        while (true) {
            nb_result = bus_req->nb_read(req);
            if (nb_result == true) {
                value_in->get(resp.data);
                resp.ack = OK;
                bus_resp->write(resp);

            }
            wait(SC_ZERO_TIME);
        }
    }
};


#endif //PROJECT_BUFFER_H
