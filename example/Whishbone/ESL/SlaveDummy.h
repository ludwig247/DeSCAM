//
// Created by tobias on 02.07.17.
//

#ifndef PROJECT_SLAVEDUMMY_H
#define PROJECT_SLAVEDUMMY_H


#include "systemc.h"
#include "Compound_Bus.h"
#include "../../SingleMasterMultiSlave/ESL/Compound.h"
#include "../../Interfaces/Interfaces.h"

struct SlaveDummy : public sc_module {
public:

    //Out-port
    blocking_in <bus_req_t> bus_req;
    blocking_out <bus_resp_t> bus_resp;


    //Variables
    bus_resp_t resp;
    bus_req_t req;

    int cnt;
    //Constructor
    SC_HAS_PROCESS(SlaveDummy);

    SlaveDummy(sc_module_name name) :
            bus_req("bus_req"),
            bus_resp("bus_resp"){
        SC_THREAD(fsm);
    }


    void fsm() {
        while (true) {

            bus_req->read(req);
            resp.data = req.data;
            resp.ack = OK;
            bus_resp->write(resp);

            wait(SC_ZERO_TIME);
        }
    }
};

#endif //PROJECT_SLAVEDUMMY_H
