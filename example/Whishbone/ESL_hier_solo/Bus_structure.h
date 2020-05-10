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
    SC_CTOR(Bus_structure) :
            masterAgent("masterAgent"),
            slaveAgent0("slaveAgent0"),
            slaveAgent1("slaveAgent1"),
            slaveAgent2("slaveAgent2"),
            slaveAgent3("slaveAgent3"),
            interconnect("interconnect"),
            masterAgentToBus("masterAgentToBus"),
            busToMasterAgent("busToMasterAgent"),
            InterConnToSlaveAgent0("InterConnToSlaveAgent0"),
            InterConnToSlaveAgent1("InterConnToSlaveAgent1"),
            InterConnToSlaveAgent2("InterConnToSlaveAgent2"),
            InterConnToSlaveAgent3("InterConnToSlaveAgent3"),
            SlaveAgentTOInterconn0("SlaveAgentTOInterconn0"),
            SlaveAgentTOInterconn1("SlaveAgentTOInterconn1"),
            SlaveAgentTOInterconn2("SlaveAgentTOInterconn2"),
            SlaveAgentTOInterconn3("SlaveAgentTOInterconn3"),
            MasterAgenToOutside_port("MasterAgenToOutside_port"),
            OutsideToMasterAgent_port("OutsideToMasterAgent_port"),
            SlaveToOutside0_port("SlaveToOutside0_port"),
            OutsideToSlave0_port("OutsideToSlave0_port"),
            SlaveToOutside1_port("SlaveToOutside1_port"),
            OutsideToSlave1_port("OutsideToSlave1_port"),
            SlaveToOutside2_port("SlaveToOutside2_port"),
            OutsideToSlave2_port("OutsideToSlave2_port"),
            SlaveToOutside3_port("SlaveToOutside3_port"),
            OutsideToSlave3_port("OutsideToSlave3_port")
            {

        //BINDINGS
        masterAgent.agent_to_bus(masterAgentToBus);
        interconnect.master_input(masterAgentToBus);
        masterAgent.bus_to_agent(busToMasterAgent);
        interconnect.master_output(busToMasterAgent);

        interconnect.slave_out0(InterConnToSlaveAgent0);
        slaveAgent0.bus_to_agent(InterConnToSlaveAgent0);
        interconnect.slave_out1(InterConnToSlaveAgent1);
        slaveAgent1.bus_to_agent(InterConnToSlaveAgent1);
        interconnect.slave_out2(InterConnToSlaveAgent2);
        slaveAgent2.bus_to_agent(InterConnToSlaveAgent2);
        interconnect.slave_out3(InterConnToSlaveAgent3);
        slaveAgent3.bus_to_agent(InterConnToSlaveAgent3);


        interconnect.slave_in0(SlaveAgentTOInterconn0);
        slaveAgent0.agent_to_bus(SlaveAgentTOInterconn0);
        interconnect.slave_in1(SlaveAgentTOInterconn1);
        slaveAgent1.agent_to_bus(SlaveAgentTOInterconn1);
        interconnect.slave_in2(SlaveAgentTOInterconn2);
        slaveAgent2.agent_to_bus(SlaveAgentTOInterconn2);
        interconnect.slave_in3(SlaveAgentTOInterconn3);
        slaveAgent3.agent_to_bus(SlaveAgentTOInterconn3);


        masterAgent.master_to_agent(MasterAgenToOutside_port);
        masterAgent.agent_to_master(OutsideToMasterAgent_port);

        slaveAgent0.agent_to_slave(SlaveToOutside0_port);
        slaveAgent0.slave_to_agent(OutsideToSlave0_port);

        slaveAgent1.agent_to_slave(SlaveToOutside1_port);
        slaveAgent1.slave_to_agent(OutsideToSlave1_port);

        slaveAgent2.agent_to_slave(SlaveToOutside2_port);
        slaveAgent2.slave_to_agent(OutsideToSlave2_port);

        slaveAgent3.agent_to_slave(SlaveToOutside3_port);
        slaveAgent3.slave_to_agent(OutsideToSlave3_port);


    }





    //sc_module_name name = "test";
    MasterAgent masterAgent;
    SlaveAgent slaveAgent0;
    SlaveAgent slaveAgent1;
    SlaveAgent slaveAgent2;
    SlaveAgent slaveAgent3;
    Interconnect interconnect;

    blocking_in<bus_resp_t> OutsideToSlave0_port;
    blocking_in<bus_resp_t> OutsideToSlave1_port;
    blocking_in<bus_resp_t> OutsideToSlave2_port;
    blocking_in<bus_resp_t> OutsideToSlave3_port;
    blocking_out<bus_resp_t> OutsideToMasterAgent_port;

    blocking_in<bus_req_t> MasterAgenToOutside_port;
    blocking_out<bus_req_t> SlaveToOutside0_port;
    blocking_out<bus_req_t> SlaveToOutside1_port;
    blocking_out<bus_req_t> SlaveToOutside2_port;
    blocking_out<bus_req_t> SlaveToOutside3_port;


    bus_req_t agent_to_bus_req;
    bus_resp_t agent_to_bus_resp;

    Shared<master_signals> masterAgentToBus;
    Shared<slave_signals> busToMasterAgent;
    Shared<master_signals> InterConnToSlaveAgent0;
    Shared<master_signals> InterConnToSlaveAgent1;
    Shared<master_signals> InterConnToSlaveAgent2;
    Shared<master_signals> InterConnToSlaveAgent3;
    Shared<slave_signals> SlaveAgentTOInterconn0;
    Shared<slave_signals> SlaveAgentTOInterconn1;
    Shared<slave_signals> SlaveAgentTOInterconn2;
    Shared<slave_signals> SlaveAgentTOInterconn3;

};


#endif //PROJECT_BUS_H
