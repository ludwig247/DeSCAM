//
// Created by ovsthus on 11/19/19.
//

#ifndef ABSTRACT_BUS_CUSTOM_PORT_H
#define ABSTRACT_BUS_CUSTOM_PORT_H

#include "compound.h"
#include "Interfaces.h"
#include "systemc.h"


struct custom_port : public sc_module {

    blocking_in<bool> agent0_request;
    blocking_in<bool> agent1_request;
    blocking_in<bool> agent2_request;
    blocking_in<bool> agent3_request;

    blocking_in<bool> update_requests;
shared_out<request_comp> requests_out;

    blocking_in<bool> bus_ready0;
    blocking_in<bool> bus_ready1;
    blocking_in<bool> bus_ready2;
    blocking_in<bool> bus_ready3;


request_comp reqs, reqs_stored;

bool dummyval, sync;
    //Constructor
    SC_HAS_PROCESS(custom_port);

    custom_port(sc_module_name name) :
            agent0_request("agent0_request"),
            agent1_request("agent1_request"),
            agent2_request("agent2_request"),
            agent3_request("agent3_request"),
            bus_ready0("bus_ready0"),
            bus_ready1("bus_ready1"),
            bus_ready2("bus_ready2"),
            bus_ready3("bus_ready3"),
            update_requests("update_requests"),
            requests_out("requests_out")

    {
        SC_THREAD(fsm);
    }




    void fsm() {
        reqs_stored.m3_request = false;
        reqs_stored.m2_request = false;
        reqs_stored.m1_request = false;
        reqs_stored.m0_request = false;


        while (true) {




            update_requests->read(sync); //wait for bus to notify to update requests port, and 


            reqs = reqs_stored;

            if (agent3_request->peek()) { // determine highest priority most recent request without advancing time
                reqs.m3_request = true;
            }else if (agent2_request->peek()) {
                reqs.m2_request = true;
            }else if (agent1_request->peek()) {
                reqs.m1_request = true;
            }else if (agent0_request->peek()) {
                reqs.m0_request = true;
            }


            requests_out->set(reqs); // write requests to port
            
            reqs_stored = reqs; // we need to store intermediate value to not change value just written to port, before it is used. 





            if (agent3_request->peek()) {
                agent3_request->try_read(sync); // unblock (hgrant = true) highest prio master agents request without advancing time
                reqs_stored.m3_request = false;
            } else if (agent2_request->peek()) {
                agent2_request->try_read(sync);
                reqs_stored.m2_request = false;
            } else if (agent1_request->peek()) {
                agent1_request->try_read(sync);
                reqs_stored.m1_request = false;
            } else if (agent0_request->peek()) {
                agent0_request->try_read(sync);
                reqs_stored.m0_request = false;
            }



            if(bus_ready0->peek()){         //we peek so we can unblock (hready = true) to all agents without advancing time
                bus_ready0->try_read(sync);
            }
            if(bus_ready1->peek()){
                bus_ready1->try_read(sync);
            }
            if(bus_ready2->peek()){
                bus_ready2->try_read(sync);
            }
            if(bus_ready3->peek()){
                bus_ready3->try_read(sync);
            }




        }
    }


};



#endif //ABSTRACT_BUS_CUSTOM_PORT_H
