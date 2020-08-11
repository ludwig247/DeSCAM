#include <iostream>


#include "ahb_bus.h"
#include "masterAgent.h"
#include "Mdummy.h"
#include "Sdummy.h"
#include "systemc.h"
#include "Interfaces.h"
#include "compound.h"
#include "custom_port.h"



int sc_main(int, char **)  {



    masterAgent agent0("agent0");
    masterAgent agent1("agent1");
    masterAgent agent2("agent2");
    masterAgent agent3("agent3");




    Mdummy m0("master_0");
    Mdummy m1("master_1");
    Mdummy m2("master_2");
    Mdummy m3("master_3");

    Sdummy s0("slave_0");
    Sdummy s1("slave_1");
    Sdummy s2("slave_2");

    custom_port c_b_p("c_b_p");
    AHB_Bus bus1("bus1");

    Shared<compound_out> bus_to_agents("bus_to_agents");
    Shared<ahb_mst_in_t> bus_to_agent0("bus_to_agent0");
    Shared<ahb_mst_in_t> bus_to_agent1("bus_to_agent1");
    Shared<ahb_mst_in_t> bus_to_agent2("bus_to_agent2");
    Shared<ahb_mst_in_t> bus_to_agent3("bus_to_agent3");





    Shared<ahb_mst_out_t> agent0_to_bus("agent0_to_bus");
    Shared<ahb_mst_out_t> agent1_to_bus("agent1_to_bus");
    Shared<ahb_mst_out_t> agent2_to_bus("agent2_to_bus");
    Shared<ahb_mst_out_t> agent3_to_bus("agent3_to_bus");


    agent0.bus_to_agent(bus_to_agent0);
    agent1.bus_to_agent(bus_to_agent1);
    agent2.bus_to_agent(bus_to_agent2);
    agent3.bus_to_agent(bus_to_agent3);

bus1.bus_to_agent0(bus_to_agent0);
    bus1.bus_to_agent1(bus_to_agent1);
    bus1.bus_to_agent2(bus_to_agent2);
    bus1.bus_to_agent3(bus_to_agent3);


    Blocking<bool> agent0_req("agent0_req");
    Blocking<bool> agent1_req("agent1_req");
    Blocking<bool> agent2_req("agent2_req");
    Blocking<bool> agent3_req("agent3_req");
    Blocking<bool> agent0_ready("agent0_ready");
    Blocking<bool> agent1_ready("agent1_ready");
    Blocking<bool> agent2_ready("agent2_ready");
    Blocking<bool> agent3_ready("agent3_ready");

    Blocking<bool> request_sync("request_sync");
    Shared<request_comp> requests("requests");



    agent0.agent_to_bus(agent0_to_bus);
    agent1.agent_to_bus(agent1_to_bus);
    agent2.agent_to_bus(agent2_to_bus);
    agent3.agent_to_bus(agent3_to_bus);
    bus1.agent_to_bus0(agent0_to_bus);
    bus1.agent_to_bus1(agent1_to_bus);
    bus1.agent_to_bus2(agent2_to_bus);
    bus1.agent_to_bus3(agent3_to_bus);
    agent0.agent_request(agent0_req);
    agent1.agent_request(agent1_req);
    agent2.agent_request(agent2_req);
    agent3.agent_request(agent3_req);
    agent0.bus_ready(agent0_ready);
    agent1.bus_ready(agent1_ready);
    agent2.bus_ready(agent2_ready);
    agent3.bus_ready(agent3_ready);
    c_b_p.bus_ready0(agent0_ready);
    c_b_p.bus_ready1(agent1_ready);
    c_b_p.bus_ready2(agent2_ready);
    c_b_p.bus_ready3(agent3_ready);
    c_b_p.update_requests(request_sync);
    c_b_p.requests_out(requests);
    c_b_p.agent0_request(agent0_req);
    c_b_p.agent1_request(agent1_req);
    c_b_p.agent2_request(agent2_req);
    c_b_p.agent3_request(agent3_req);
    bus1.update_requests(request_sync);
    bus1.requests_in(requests);



    Blocking<bus_req_t> md0_to_mcl("md0_to_mcl");
    Blocking<bus_req_t> md1_to_mcl("md1_to_mcl");
    Blocking<bus_req_t> md2_to_mcl("md2_to_mcl");
    Blocking<bus_req_t> md3_to_mcl("md3_to_mcl");
    Blocking<bus_resp_t> mcl_to_md0("mcl_to_md0");
    Blocking<bus_resp_t> mcl_to_md1("mcl_to_md1");
    Blocking<bus_resp_t> mcl_to_md2("mcl_to_md2");
    Blocking<bus_resp_t> mcl_to_md3("mcl_to_md3");

    m0.master_out(md0_to_mcl);
    agent0.master_to_agent(md0_to_mcl);
    m1.master_out(md1_to_mcl);
    agent1.master_to_agent(md1_to_mcl);
    m2.master_out(md2_to_mcl);
    agent2.master_to_agent(md2_to_mcl);
    m3.master_out(md3_to_mcl);
    agent3.master_to_agent(md3_to_mcl);
    m0.master_in(mcl_to_md0);
    agent0.agent_to_master(mcl_to_md0);
    m1.master_in(mcl_to_md1);
    agent1.agent_to_master(mcl_to_md1);
    m2.master_in(mcl_to_md2);
    agent2.agent_to_master(mcl_to_md2);
    m3.master_in(mcl_to_md3);
    agent3.agent_to_master(mcl_to_md3);


    Blocking<ahb_to_slv> ahb_to_slv0("ahb_to_slv0");
    Blocking<ahb_to_slv> ahb_to_slv1("ahb_to_slv1");
    Blocking<ahb_to_slv> ahb_to_slv2("ahb_to_slv2");
    Blocking<slv_to_mst> slv2_to_ahb("slv2_to_ahb");
    Blocking<slv_to_mst> slv1_to_ahb("slv1_to_ahb");
    Blocking<slv_to_mst> slv0_to_ahb("slv0_to_ahb");

    s0.bus_in(ahb_to_slv0);
    s1.bus_in(ahb_to_slv1);
    s2.bus_in(ahb_to_slv2);
    bus1.slave_out0(ahb_to_slv0);
    bus1.slave_out1(ahb_to_slv1);
    bus1.slave_out2(ahb_to_slv2);

    s0.bus_out(slv0_to_ahb);
    s1.bus_out(slv1_to_ahb);
    s2.bus_out(slv2_to_ahb);
    bus1.slave_in0(slv0_to_ahb);
    bus1.slave_in1(slv1_to_ahb);
    bus1.slave_in2(slv2_to_ahb);


    sc_start();
    return 0;
}