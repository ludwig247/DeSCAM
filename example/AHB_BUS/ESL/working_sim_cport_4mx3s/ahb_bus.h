//
// Created by ovsthus on 19.08.19.
//



#ifndef ABSTRACT_BUS_AHB_BUS_H
#define ABSTRACT_BUS_AHB_BUS_H

#include "Interfaces.h"
#include "compound.h"
#include "systemc.h"


struct AHB_Bus : public sc_module {

    //In-port


    enum phases {idle_state, address_state, data_state}; //these names cant exactly match phases in master agent, maybe start with capital letters, onespin cant resolve enum type
    phases phase, nextphase;




    blocking_in<slv_to_mst> slave_in0;
    blocking_in<slv_to_mst> slave_in1;
    blocking_in<slv_to_mst> slave_in2;


    shared_in<ahb_mst_out_t> agent_to_bus0;
    shared_in<ahb_mst_out_t> agent_to_bus1;
    shared_in<ahb_mst_out_t> agent_to_bus2;
    shared_in<ahb_mst_out_t> agent_to_bus3;

blocking_out<bool> update_requests; //used to release the blocked agents, needs to be outport because of mandatory wait for non blocking write.
                             // The bus must not outrun the other modules.

    shared_in<request_comp> requests_in;                             

    shared_out<ahb_mst_in_t> bus_to_agent0;
    shared_out<ahb_mst_in_t> bus_to_agent1;
    shared_out<ahb_mst_in_t> bus_to_agent2;
    shared_out<ahb_mst_in_t> bus_to_agent3;

    ahb_mst_in_t to_agent0;
    ahb_mst_in_t to_agent1;
    ahb_mst_in_t to_agent2;
    ahb_mst_in_t to_agent3;


    blocking_out<ahb_to_slv> slave_out0;
    blocking_out<ahb_to_slv> slave_out1;
    blocking_out<ahb_to_slv> slave_out2;

request_comp reqs;

    ahb_mst_out_t payload0, payload1, payload2, payload3;


bool sync, sync1;
    //Variables
    mst_to_ahb request;
    ahb_to_slv request_pipelined;
    slv_to_mst resp;


    //Constructor
    SC_HAS_PROCESS(AHB_Bus);

    AHB_Bus(sc_module_name name) :
            agent_to_bus0("agent_to_bus0"),
            agent_to_bus1("agent_to_bus1"),
            agent_to_bus2("agent_to_bus2"),
            agent_to_bus3("agent_to_bus3"),
            bus_to_agent0("bus_to_agent0"),
            bus_to_agent1("bus_to_agent1"),
            bus_to_agent2("bus_to_agent2"),
            bus_to_agent3("bus_to_agent3"),
            update_requests("update_requests"),
            requests_in("requests_in"),
            slave_out0("slave_out0"),
            slave_out1("slave_out1"),
            slave_out2("slave_out2"),
            slave_in0("slave_in0"),
            slave_in1("slave_in1"),
            slave_in2("slave_in2")
 {
        SC_THREAD(fsm);
    }


    void fsm() {

        request.hsize = MT_W;
        request_pipelined.hsize = MT_W;

        to_agent0.hresp = 0;
        to_agent0.hrdata = 0;
        to_agent0.hgrant = m0_grant;
        to_agent1.hresp = 0;
        to_agent1.hrdata = 0;
        to_agent1.hgrant = m1_grant;
        to_agent2.hresp = 0;
        to_agent2.hrdata = 0;
        to_agent2.hgrant = m2_grant;
        to_agent3.hresp = 0;
        to_agent3.hrdata = 0;
        to_agent3.hgrant = m3_grant;
        bus_to_agent0->set(to_agent0);
        bus_to_agent1->set(to_agent1);
        bus_to_agent2->set(to_agent2);
        bus_to_agent3->set(to_agent3);

        nextphase = idle_state;
        while (true) {

            phase = nextphase;



            if(phase == idle_state){




                update_requests->try_write(true, sync1); //we use write here to always call wait before reading requests in.
                requests_in->get(reqs); //fetches most recent highest priority request

                agent_to_bus0->get(payload0);
                agent_to_bus1->get(payload1);
                agent_to_bus2->get(payload2);
                agent_to_bus3->get(payload3);


if(sync1) {

    if (reqs.m3_request) {
        request.haddr = payload3.haddr;
        request.hwdata = payload3.hwdata;
        request.htrans = nonseq;
        request.hwrite = payload3.hwrite;
        request.hsize = payload3.hsize;
        nextphase = address_state;
    } else if (reqs.m2_request) {
        request.haddr = payload2.haddr;
        request.hwdata = payload2.hwdata;
        request.htrans = nonseq;
        request.hwrite = payload2.hwrite;
        request.hsize = payload2.hsize;
        nextphase = address_state;
    } else if (reqs.m1_request) {
        request.haddr = payload1.haddr;
        request.hwdata = payload1.hwdata;
        request.htrans = nonseq;
        request.hwrite = payload1.hwrite;
        request.hsize = payload1.hsize;
        nextphase = address_state;
    } else if (reqs.m0_request) {
        request.haddr = payload0.haddr;
        request.hwdata = payload0.hwdata;
        request.htrans = nonseq;
        request.hwrite = payload0.hwrite;
        request.hsize = payload0.hsize;
        nextphase = address_state;
    }


}

                to_agent0.hresp = 0;
                to_agent0.hrdata = 0;
                to_agent0.hgrant = m0_grant;
                to_agent1.hresp = 0;
                to_agent1.hrdata = 0;
                to_agent1.hgrant = m1_grant;
                to_agent2.hresp = 0;
                to_agent2.hrdata = 0;
                to_agent2.hgrant = m2_grant;
                to_agent3.hresp = 0;
                to_agent3.hrdata = 0;
                to_agent3.hgrant = m3_grant;
                bus_to_agent0->set(to_agent0);
                bus_to_agent1->set(to_agent1);
                bus_to_agent2->set(to_agent2);
                bus_to_agent3->set(to_agent3);


            }

            if(phase == address_state){




                update_requests->try_write(true);
                requests_in->get(reqs);

                agent_to_bus0->get(payload0);
                agent_to_bus1->get(payload1);
                agent_to_bus2->get(payload2);
                agent_to_bus3->get(payload3);



                request_pipelined.haddr = request.haddr;
                request_pipelined.hwdata = request.hwdata;
                request_pipelined.hwrite = request.hwrite;
                request_pipelined.hsize = request.hsize;



                if(reqs.m3_request){
                    request.haddr = payload3.haddr;
                    request.hwdata = payload3.hwdata;
                    request.htrans = nonseq;
                    request.hwrite = payload3.hwrite;
                    request.hsize = payload3.hsize;
                }else if(reqs.m2_request){
                    request.haddr = payload2.haddr;
                    request.hwdata = payload2.hwdata;
                    request.htrans = nonseq;
                    request.hwrite = payload2.hwrite;
                    request.hsize = payload2.hsize;
                }else if (reqs.m1_request) {
                    request.haddr = payload1.haddr;
                    request.hwdata = payload1.hwdata;
                    request.htrans = nonseq;
                    request.hwrite = payload1.hwrite;
                    request.hsize = payload1.hsize;
                } else if (reqs.m0_request) {
                    request.haddr = payload0.haddr;
                    request.hwdata = payload0.hwdata;
                    request.htrans = nonseq;
                    request.hwrite = payload0.hwrite;
                    request.hsize = payload0.hsize;
                }else{
                    request.haddr = 0;
                    request.hwdata = 0;
                    request.htrans = idle;
                    request.hwrite = AHB_READ;
                    request.hsize = MT_W;
                };


                to_agent0.hresp = 0;
                to_agent0.hrdata = 0;
                to_agent0.hgrant = m0_grant;
                to_agent1.hresp = 0;
                to_agent1.hrdata = 0;
                to_agent1.hgrant = m1_grant;
                to_agent2.hresp = 0;
                to_agent2.hrdata = 0;
                to_agent2.hgrant = m2_grant;
                to_agent3.hresp = 0;
                to_agent3.hrdata = 0;
                to_agent3.hgrant = m3_grant;
                bus_to_agent0->set(to_agent0);
                bus_to_agent1->set(to_agent1);
                bus_to_agent2->set(to_agent2);
                bus_to_agent3->set(to_agent3);
                nextphase = data_state;
            }


            if(phase == data_state){



                if(request_pipelined.haddr >= SLAVE0_START && request_pipelined.haddr < SLAVE0_END){
                 wait(WAIT_TIME, SC_PS);
                    to_agent0.hresp = 0;
                    to_agent0.hrdata = 0;
                    to_agent0.hgrant = m0_grant;
                    to_agent1.hresp = 0;
                    to_agent1.hrdata = 0;
                    to_agent1.hgrant = m1_grant;
                    to_agent2.hresp = 0;
                    to_agent2.hrdata = 0;
                    to_agent2.hgrant = m2_grant;
                    to_agent3.hresp = 0;
                    to_agent3.hrdata = 0;
                    to_agent3.hgrant = m3_grant;
                    bus_to_agent0->set(to_agent0);
                    bus_to_agent1->set(to_agent1);
                    bus_to_agent2->set(to_agent2);
                    bus_to_agent3->set(to_agent3);
                    slave_out0->write(request_pipelined);
                    to_agent0.hresp = 0;
                    to_agent0.hrdata = 0;
                    to_agent0.hgrant = m0_grant;
                    to_agent1.hresp = 0;
                    to_agent1.hrdata = 0;
                    to_agent1.hgrant = m1_grant;
                    to_agent2.hresp = 0;
                    to_agent2.hrdata = 0;
                    to_agent2.hgrant = m2_grant;
                    to_agent3.hresp = 0;
                    to_agent3.hrdata = 0;
                    to_agent3.hgrant = m3_grant;
                    bus_to_agent0->set(to_agent0);
                    bus_to_agent1->set(to_agent1);
                    bus_to_agent2->set(to_agent2);
                    bus_to_agent3->set(to_agent3);
                    slave_in0->read(resp);
                    to_agent0.hresp = resp.hresp;
                    to_agent0.hrdata = resp.hrdata;
                    to_agent0.hgrant = m0_grant;
                    to_agent1.hresp = resp.hresp;
                    to_agent1.hrdata = resp.hrdata;
                    to_agent1.hgrant = m1_grant;
                    to_agent2.hresp = resp.hresp;
                    to_agent2.hrdata = resp.hrdata;
                    to_agent2.hgrant = m2_grant;
                    to_agent3.hresp = resp.hresp;
                    to_agent3.hrdata = resp.hrdata;
                    to_agent3.hgrant = m3_grant;
                    bus_to_agent0->set(to_agent0);
                    bus_to_agent1->set(to_agent1);
                    bus_to_agent2->set(to_agent2);
                    bus_to_agent3->set(to_agent3);
                   wait(WAIT_TIME, SC_PS);
                    to_agent0.hresp = resp.hresp;
                    to_agent0.hrdata = resp.hrdata;
                    to_agent0.hgrant = m0_grant;
                    to_agent1.hresp = resp.hresp;
                    to_agent1.hrdata = resp.hrdata;
                    to_agent1.hgrant = m1_grant;
                    to_agent2.hresp = resp.hresp;
                    to_agent2.hrdata = resp.hrdata;
                    to_agent2.hgrant = m2_grant;
                    to_agent3.hresp = resp.hresp;
                    to_agent3.hrdata = resp.hrdata;
                    to_agent3.hgrant = m3_grant;
                    bus_to_agent0->set(to_agent0);
                    bus_to_agent1->set(to_agent1);
                    bus_to_agent2->set(to_agent2);
                    bus_to_agent3->set(to_agent3);

                }else if(request_pipelined.haddr >= SLAVE1_START && request_pipelined.haddr < SLAVE1_END){
                   wait(WAIT_TIME, SC_PS);
                    to_agent0.hresp = 0;
                    to_agent0.hrdata = 0;
                    to_agent0.hgrant = m0_grant;
                    to_agent1.hresp = 0;
                    to_agent1.hrdata = 0;
                    to_agent1.hgrant = m1_grant;
                    to_agent2.hresp = 0;
                    to_agent2.hrdata = 0;
                    to_agent2.hgrant = m2_grant;
                    to_agent3.hresp = 0;
                    to_agent3.hrdata = 0;
                    to_agent3.hgrant = m3_grant;
                    bus_to_agent0->set(to_agent0);
                    bus_to_agent1->set(to_agent1);
                    bus_to_agent2->set(to_agent2);
                    bus_to_agent3->set(to_agent3);
                    request_pipelined.haddr = request_pipelined.haddr - SLAVE1_START;
                    slave_out1->write(request_pipelined);
                    request_pipelined.haddr = request_pipelined.haddr + SLAVE1_START;

                    to_agent0.hresp = 0;
                    to_agent0.hrdata = 0;
                    to_agent0.hgrant = m0_grant;
                    to_agent1.hresp = 0;
                    to_agent1.hrdata = 0;
                    to_agent1.hgrant = m1_grant;
                    to_agent2.hresp = 0;
                    to_agent2.hrdata = 0;
                    to_agent2.hgrant = m2_grant;
                    to_agent3.hresp = 0;
                    to_agent3.hrdata = 0;
                    to_agent3.hgrant = m3_grant;
                    bus_to_agent0->set(to_agent0);
                    bus_to_agent1->set(to_agent1);
                    bus_to_agent2->set(to_agent2);
                    bus_to_agent3->set(to_agent3);
                    slave_in1->read(resp);

                    to_agent0.hresp = resp.hresp;
                    to_agent0.hrdata = resp.hrdata;
                    to_agent0.hgrant = m0_grant;
                    to_agent1.hresp = resp.hresp;
                    to_agent1.hrdata = resp.hrdata;
                    to_agent1.hgrant = m1_grant;
                    to_agent2.hresp = resp.hresp;
                    to_agent2.hrdata = resp.hrdata;
                    to_agent2.hgrant = m2_grant;
                    to_agent3.hresp = resp.hresp;
                    to_agent3.hrdata = resp.hrdata;
                    to_agent3.hgrant = m3_grant;
                    bus_to_agent0->set(to_agent0);
                    bus_to_agent1->set(to_agent1);
                    bus_to_agent2->set(to_agent2);
                    bus_to_agent3->set(to_agent3);
                   wait(WAIT_TIME, SC_PS);

                    to_agent0.hresp = resp.hresp;
                    to_agent0.hrdata = resp.hrdata;
                    to_agent0.hgrant = m0_grant;
                    to_agent1.hresp = resp.hresp;
                    to_agent1.hrdata = resp.hrdata;
                    to_agent1.hgrant = m1_grant;
                    to_agent2.hresp = resp.hresp;
                    to_agent2.hrdata = resp.hrdata;
                    to_agent2.hgrant = m2_grant;
                    to_agent3.hresp = resp.hresp;
                    to_agent3.hrdata = resp.hrdata;
                    to_agent3.hgrant = m3_grant;
                    bus_to_agent0->set(to_agent0);
                    bus_to_agent1->set(to_agent1);
                    bus_to_agent2->set(to_agent2);
                    bus_to_agent3->set(to_agent3);
                }else if(request_pipelined.haddr >= SLAVE2_START && request_pipelined.haddr < SLAVE2_END){
                   wait(WAIT_TIME, SC_PS);

                    to_agent0.hresp = 0;
                    to_agent0.hrdata = 0;
                    to_agent0.hgrant = m0_grant;
                    to_agent1.hresp = 0;
                    to_agent1.hrdata = 0;
                    to_agent1.hgrant = m1_grant;
                    to_agent2.hresp = 0;
                    to_agent2.hrdata = 0;
                    to_agent2.hgrant = m2_grant;
                    to_agent3.hresp = 0;
                    to_agent3.hrdata = 0;
                    to_agent3.hgrant = m3_grant;
                    bus_to_agent0->set(to_agent0);
                    bus_to_agent1->set(to_agent1);
                    bus_to_agent2->set(to_agent2);
                    bus_to_agent3->set(to_agent3);
                    request_pipelined.haddr = request_pipelined.haddr - SLAVE2_START;
                    slave_out2->write(request_pipelined);
                    request_pipelined.haddr = request_pipelined.haddr + SLAVE2_START;

                    to_agent0.hresp = 0;
                    to_agent0.hrdata = 0;
                    to_agent0.hgrant = m0_grant;
                    to_agent1.hresp = 0;
                    to_agent1.hrdata = 0;
                    to_agent1.hgrant = m1_grant;
                    to_agent2.hresp = 0;
                    to_agent2.hrdata = 0;
                    to_agent2.hgrant = m2_grant;
                    to_agent3.hresp = 0;
                    to_agent3.hrdata = 0;
                    to_agent3.hgrant = m3_grant;
                    bus_to_agent0->set(to_agent0);
                    bus_to_agent1->set(to_agent1);
                    bus_to_agent2->set(to_agent2);
                    bus_to_agent3->set(to_agent3);
                    slave_in2->read(resp);


                    to_agent0.hresp = resp.hresp;
                    to_agent0.hrdata = resp.hrdata;
                    to_agent0.hgrant = m0_grant;
                    to_agent1.hresp = resp.hresp;
                    to_agent1.hrdata = resp.hrdata;
                    to_agent1.hgrant = m1_grant;
                    to_agent2.hresp = resp.hresp;
                    to_agent2.hrdata = resp.hrdata;
                    to_agent2.hgrant = m2_grant;
                    to_agent3.hresp = resp.hresp;
                    to_agent3.hrdata = resp.hrdata;
                    to_agent3.hgrant = m3_grant;
                    bus_to_agent0->set(to_agent0);
                    bus_to_agent1->set(to_agent1);
                    bus_to_agent2->set(to_agent2);
                    bus_to_agent3->set(to_agent3);
                   wait(WAIT_TIME, SC_PS);

                    to_agent0.hresp = resp.hresp;
                    to_agent0.hrdata = resp.hrdata;
                    to_agent0.hgrant = m0_grant;
                    to_agent1.hresp = resp.hresp;
                    to_agent1.hrdata = resp.hrdata;
                    to_agent1.hgrant = m1_grant;
                    to_agent2.hresp = resp.hresp;
                    to_agent2.hrdata = resp.hrdata;
                    to_agent2.hgrant = m2_grant;
                    to_agent3.hresp = resp.hresp;
                    to_agent3.hrdata = resp.hrdata;
                    to_agent3.hgrant = m3_grant;
                    bus_to_agent0->set(to_agent0);
                    bus_to_agent1->set(to_agent1);
                    bus_to_agent2->set(to_agent2);
                    bus_to_agent3->set(to_agent3);

                }else{

                    to_agent0.hresp = 1;
                    to_agent0.hrdata = 0;
                    to_agent0.hgrant = m0_grant;
                    to_agent1.hresp = 1;
                    to_agent1.hrdata = 0;
                    to_agent1.hgrant = m1_grant;
                    to_agent2.hresp = 1;
                    to_agent2.hrdata = 0;
                    to_agent2.hgrant = m2_grant;
                    to_agent3.hresp = 1;
                    to_agent3.hrdata = 0;
                    to_agent3.hgrant = m3_grant;
                    bus_to_agent0->set(to_agent0);
                    bus_to_agent1->set(to_agent1);
                    bus_to_agent2->set(to_agent2);
                    bus_to_agent3->set(to_agent3);
                   wait(WAIT_TIME, SC_PS);


                    to_agent0.hresp = 1;
                    to_agent0.hrdata = 0;
                    to_agent0.hgrant = m0_grant;
                    to_agent1.hresp = 1;
                    to_agent1.hrdata = 0;
                    to_agent1.hgrant = m1_grant;
                    to_agent2.hresp = 1;
                    to_agent2.hrdata = 0;
                    to_agent2.hgrant = m2_grant;
                    to_agent3.hresp = 1;
                    to_agent3.hrdata = 0;
                    to_agent3.hgrant = m3_grant;
                    bus_to_agent0->set(to_agent0);
                    bus_to_agent1->set(to_agent1);
                    bus_to_agent2->set(to_agent2);
                    bus_to_agent3->set(to_agent3);
   

                }




                update_requests->try_write(true);
                requests_in->get(reqs);



                agent_to_bus0->get(payload0);
                agent_to_bus1->get(payload1);
                agent_to_bus2->get(payload2);
                agent_to_bus3->get(payload3);



                resp.hresp = 0;
                resp.hrdata = 0;


                to_agent0.hresp = 0;
                to_agent0.hrdata = 0;
                to_agent0.hgrant = m0_grant;
                to_agent1.hresp = 0;
                to_agent1.hrdata = 0;
                to_agent1.hgrant = m1_grant;
                to_agent2.hresp = 0;
                to_agent2.hrdata = 0;
                to_agent2.hgrant = m2_grant;
                to_agent3.hresp = 0;
                to_agent3.hrdata = 0;
                to_agent3.hgrant = m3_grant;

                if(request.htrans == nonseq){
                    request_pipelined.haddr = request.haddr;
                    request_pipelined.hwdata = request.hwdata;
                    request_pipelined.hwrite = request.hwrite;
                    request_pipelined.hsize = request.hsize;
                    nextphase = data_state;
                    if(reqs.m3_request){
                        request.haddr = payload3.haddr;
                        request.hwdata = payload3.hwdata;
                        request.htrans = nonseq;
                        request.hwrite = payload3.hwrite;
                        request.hsize = payload3.hsize;
                    }else if(reqs.m2_request){
                        request.haddr = payload2.haddr;
                        request.hwdata = payload2.hwdata;
                        request.htrans = nonseq;
                        request.hwrite = payload2.hwrite;
                        request.hsize = payload2.hsize;
                    }else if(reqs.m1_request){
                        request.haddr = payload1.haddr;
                        request.hwdata = payload1.hwdata;
                        request.htrans = nonseq;
                        request.hwrite = payload1.hwrite;
                        request.hsize = payload1.hsize;
                    }else if(reqs.m0_request){
                        request.haddr = payload0.haddr;
                        request.hwdata = payload0.hwdata;
                        request.htrans = nonseq;
                        request.hwrite = payload0.hwrite;
                        request.hsize = payload0.hsize;
                    }else{
                        request.haddr = 0;
                        request.hwdata = 0;
                        request.htrans = idle;
                        request.hwrite = AHB_READ;
                        request.hsize = MT_W;
                    }
                } else{
                    request_pipelined.haddr = 0;
                    request_pipelined.hwdata = 0;
                    request_pipelined.hwrite = AHB_READ;
                    request_pipelined.hsize = MT_W;
                    if(reqs.m3_request){
                        request.haddr = payload3.haddr;
                        request.hwdata = payload3.hwdata;
                        request.htrans = nonseq;
                        request.hwrite = payload3.hwrite;
                        request.hsize = payload3.hsize;
                        nextphase = address_state;
                    }else if(reqs.m2_request){
                        request.haddr = payload2.haddr;
                        request.hwdata = payload2.hwdata;
                        request.htrans = nonseq;
                        request.hwrite = payload2.hwrite;
                        request.hsize = payload2.hsize;
                        nextphase = address_state;
                    }else if(reqs.m1_request){
                        request.haddr = payload1.haddr;
                        request.hwdata = payload1.hwdata;
                        request.htrans = nonseq;
                        request.hwrite = payload1.hwrite;
                        request.hsize = payload1.hsize;
                        nextphase = address_state;
                    }else if(reqs.m0_request){
                        request.haddr = payload0.haddr;
                        request.hwdata = payload0.hwdata;
                        request.htrans = nonseq;
                        request.hwrite = payload0.hwrite;
                        request.hsize = payload0.hsize;
                        nextphase = address_state;
                    }else{
                        request.haddr = 0;
                        request.hwdata = 0;
                        request.htrans = idle;
                        request.hwrite = AHB_READ;
                        request.hsize = MT_W;
                        nextphase = idle_state;
                    }
                }

                bus_to_agent0->set(to_agent0);
                bus_to_agent1->set(to_agent1);
                bus_to_agent2->set(to_agent2);
                bus_to_agent3->set(to_agent3);



            }





        }
    }
};




#endif //ABSTRACT_BUS_AHB_BUS_H
