//
// Created by ovsthus on 04.10.19.
//

#ifndef ABSTRACT_BUS_MASTERAGENT_H
#define ABSTRACT_BUS_MASTERAGENT_H





#include "Interfaces.h"
#include "compound.h"


struct masterAgent : public sc_module {



    blocking_in<bus_req_t> master_to_agent;
    blocking_out<bus_resp_t> agent_to_master;

    blocking_out<bool> agent_request;
    blocking_out<bool> bus_ready; //make this output so interface can see if one is waiting


    shared_in<ahb_mst_in_t> bus_to_agent;
    shared_out<ahb_mst_out_t> agent_to_bus;


    bus_req_t req;
    bus_resp_t response;


    ahb_mst_out_t ahb_mst_out;
    ahb_mst_in_t ahb_mst_in;




   mAgent_sec master_stage, nextphase;

    //Constructor
    SC_HAS_PROCESS(masterAgent);

    masterAgent(sc_module_name name) :
            master_to_agent("master_to_agent"),
            agent_to_master("agent_to_master"),
            agent_request("agent_request"),
            bus_ready("bus_ready"),
            bus_to_agent("bus_to_agent"),
            agent_to_bus("agent_to_bus")

    {
        SC_THREAD(fsm);
    }


    void fsm() {
req.hsize = MT_W;
ahb_mst_out.hsize = MT_W;
ahb_mst_out.hprot = 3;
ahb_mst_out.hlock = false;
ahb_mst_out.hburst = 0;
ahb_mst_out.htrans = idle;
agent_to_bus->set(ahb_mst_out);
nextphase = idle_phase;

        while (true) {

            master_stage = nextphase;

            if(master_stage == idle_phase) {
                master_to_agent->read(req);
                ahb_mst_out.haddr = req.haddr;
                ahb_mst_out.hwrite = req.hwrite;
                ahb_mst_out.hwdata = req.hwdata;
                ahb_mst_out.hsize = req.hsize;
                agent_to_bus->set(ahb_mst_out);

                nextphase = request_phase;
            }

            if(master_stage == request_phase) {



                agent_request->write(true); //request bus access




                nextphase = address_phase;

            }


            if(master_stage == address_phase) {
                ahb_mst_out.htrans = nonseq;
                agent_to_bus->set(ahb_mst_out);


                bus_ready->write(true); //wait for bus to set hready = true


                    ahb_mst_out.htrans = idle;
                    agent_to_bus->set(ahb_mst_out);

                    nextphase = data_phase;



            }

            if(master_stage == data_phase) {


                bus_ready->write(true); //wait for bus to set hready = true

                    bus_to_agent->get(ahb_mst_in);


                    assert((ahb_mst_in.hrdata != 0 || ahb_mst_in.hresp != 0) && "something went wrong, out of sync");

                    response.hresp = ahb_mst_in.hresp;
                    response.hrdata = ahb_mst_in.hrdata;



                    nextphase = response_phase;


            }



            if(master_stage == response_phase){


                agent_to_master->write(response);
                nextphase = idle_phase;

            }


        }
    }
};





#endif //ABSTRACT_BUS_MASTERAGENT_H
