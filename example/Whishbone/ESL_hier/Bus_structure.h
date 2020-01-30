//
// Created by ludwig on 30.01.17.
//


#ifndef PROJECT_BUS_H
#define PROJECT_BUS_H

#include "../../SingleMasterMultiSlave/ESL/Compound.h"
#include "../../Interfaces/Interfaces.h"
#include "Compound_Bus.h"
#include "Interconnect.h"
#include "MasterAgent.h"
#include "SlaveAgent.h"
#include "systemc.h"

struct Bus_structure : public sc_module {

    //Constructor
    SC_CTOR(Bus_structure):
            master_in("master_in"),
            master_out("master_out"),
            slave_out0("slave_out0"),
            slave_out1("slave_out1"),
            slave_out2("slave_out2"),
            slave_out3("slave_out3"),
            slave_in0("slave_in0"),
            slave_in1("slave_in1"),
            slave_in2("slave_in2"),
            slave_in3("slave_in3"),
            masterAgent("masterAgent"),
            slaveAgent0("slaveAgent0"),
            slaveAgent1("slaveAgent1"),
            slaveAgent2("slaveAgent2"),
            slaveAgent3("slaveAgent3"),
            interconnect("interconnect"),
            masterAgentToBus("masterAgentToBus")
            {
                //BINDINGS
                masterAgent.agent_to_bus(masterAgentToBus);
                interconnect.master_input(masterAgentToBus);
    }

    //In-port
    blocking_in<bus_req_t> master_in;
    blocking_in<bus_resp_t> slave_in0;
    blocking_in<bus_resp_t> slave_in1;
    blocking_in<bus_resp_t> slave_in2;
    blocking_in<bus_resp_t> slave_in3;


    //Out-por
    blocking_out<bus_resp_t> master_out;
    blocking_out<bus_req_t> slave_out0;
    blocking_out<bus_req_t> slave_out1;
    blocking_out<bus_req_t> slave_out2;
    blocking_out<bus_req_t> slave_out3;

    //sc_module_name name = "test";
    MasterAgent masterAgent;
    SlaveAgent slaveAgent0;
    SlaveAgent slaveAgent1;
    SlaveAgent slaveAgent2;
    SlaveAgent slaveAgent3;
    Interconnect interconnect;
//
//    //Bus
    Shared<master_signals> masterAgentToBus;

//    interconnect.master_input(masterAgentToBus);
//    Shared<slave_signals> busToMasterAgent("busToMasterAgent");
//    masterAgent.bus_to_agent(busToMasterAgent);
//    interconnect.master_output(busToMasterAgent);
//
//    Shared<master_signals> InterConnToSlaveAgent0("InterConnToSlaveAgent0");
//    interconnect.slave_out0(InterConnToSlaveAgent0);
//    slaveAgent0.bus_to_agent(InterConnToSlaveAgent0);
//    Shared<master_signals> InterConnToSlaveAgent1("InterConnToSlaveAgent1");
//    interconnect.slave_out1(InterConnToSlaveAgent1);
//    slaveAgent1.bus_to_agent(InterConnToSlaveAgent1);
//    Shared<master_signals> InterConnToSlaveAgent2("InterConnToSlaveAgent2");
//    interconnect.slave_out2(InterConnToSlaveAgent2);
//    slaveAgent2.bus_to_agent(InterConnToSlaveAgent2);
//    Shared<master_signals> InterConnToSlaveAgent3("InterConnToSlaveAgent3");
//    interconnect.slave_out3(InterConnToSlaveAgent3);
//    slaveAgent3.bus_to_agent(InterConnToSlaveAgent3);
//
//
//    Shared<slave_signals> SlaveAgentTOInterconn0("SlaveAgentTOInterconn0");
//    interconnect.slave_in0(SlaveAgentTOInterconn0);
//    slaveAgent0.agent_to_bus(SlaveAgentTOInterconn0);
//    Shared<slave_signals> SlaveAgentTOInterconn1("SlaveAgentTOInterconn1");
//    interconnect.slave_in1(SlaveAgentTOInterconn1);
//    slaveAgent1.agent_to_bus(SlaveAgentTOInterconn1);
//    Shared<slave_signals> SlaveAgentTOInterconn2("SlaveAgentTOInterconn2");
//    interconnect.slave_in2(SlaveAgentTOInterconn2);
//    slaveAgent2.agent_to_bus(SlaveAgentTOInterconn2);
//    Shared<slave_signals> SlaveAgentTOInterconn3("SlaveAgentTOInterconn3");
//    interconnect.slave_in3(SlaveAgentTOInterconn3);
//    slaveAgent3.agent_to_bus(SlaveAgentTOInterconn3);

};


#endif //PROJECT_BUS_H
