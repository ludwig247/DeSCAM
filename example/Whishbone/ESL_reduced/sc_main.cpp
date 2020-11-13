#include "systemc.h"
#include "MasterAgent.h"
#include "SlaveAgent.h"
#include "Interconnect.h"
#include "SlaveDummy.h"
#include "MasterDummy.h"
#include "Clk.h"

using namespace std;

int sc_main(int, char **) {

    MasterAgent masterAgent("masterAgent");
    SlaveAgent slaveAgent0("slaveAgent0");
    SlaveAgent slaveAgent1("slaveAgent1");
    SlaveAgent slaveAgent2("slaveAgent2");
    SlaveAgent slaveAgent3("slaveAgent3");
    Interconnect interconnect("interconnect");

    Clk clk("clk");
    //CLK
    MasterSlave<bool> clk1("clk1");
    masterAgent.clk(clk1);
    clk.clk1(clk1);

    MasterSlave<bool> clk2("clk2");
    interconnect.clk(clk2);
    clk.clk2(clk2);

    MasterSlave<bool> clk3("clk3");
    slaveAgent0.clk(clk3);
    clk.clk3(clk3);

    MasterSlave<bool> clk4("clk4");
    slaveAgent1.clk(clk4);
    clk.clk4(clk4);

    MasterSlave<bool> clk5("clk5");
    slaveAgent2.clk(clk5);
    clk.clk5(clk5);

    MasterSlave<bool> clk6("clk6");
    slaveAgent3.clk(clk6);
    clk.clk6(clk6);



    //Bus
    Shared<master_signals> masterAgentToBus("masterAgentToBus");
    masterAgent.agent_to_bus(masterAgentToBus);
    interconnect.master_input(masterAgentToBus);
    Shared<slave_signals> busToMasterAgent("busToMasterAgent");
    masterAgent.bus_to_agent(busToMasterAgent);
    interconnect.master_output(busToMasterAgent);

    Shared<master_signals> InterConnToSlaveAgent0("InterConnToSlaveAgent0");
    interconnect.slave_out0(InterConnToSlaveAgent0);
    slaveAgent0.bus_to_agent(InterConnToSlaveAgent0);
    Shared<master_signals> InterConnToSlaveAgent1("InterConnToSlaveAgent1");
    interconnect.slave_out1(InterConnToSlaveAgent1);
    slaveAgent1.bus_to_agent(InterConnToSlaveAgent1);
    Shared<master_signals> InterConnToSlaveAgent2("InterConnToSlaveAgent2");
    interconnect.slave_out2(InterConnToSlaveAgent2);
    slaveAgent2.bus_to_agent(InterConnToSlaveAgent2);
    Shared<master_signals> InterConnToSlaveAgent3("InterConnToSlaveAgent3");
    interconnect.slave_out3(InterConnToSlaveAgent3);
    slaveAgent3.bus_to_agent(InterConnToSlaveAgent3);


    Shared<slave_signals> SlaveAgentTOInterconn0("SlaveAgentTOInterconn0");
    interconnect.slave_in0(SlaveAgentTOInterconn0);
    slaveAgent0.agent_to_bus(SlaveAgentTOInterconn0);
    Shared<slave_signals> SlaveAgentTOInterconn1("SlaveAgentTOInterconn1");
    interconnect.slave_in1(SlaveAgentTOInterconn1);
    slaveAgent1.agent_to_bus(SlaveAgentTOInterconn1);
    Shared<slave_signals> SlaveAgentTOInterconn2("SlaveAgentTOInterconn2");
    interconnect.slave_in2(SlaveAgentTOInterconn2);
    slaveAgent2.agent_to_bus(SlaveAgentTOInterconn2);
    Shared<slave_signals> SlaveAgentTOInterconn3("SlaveAgentTOInterconn3");
    interconnect.slave_in3(SlaveAgentTOInterconn3);
    slaveAgent3.agent_to_bus(SlaveAgentTOInterconn3);

    //std::cout << sc_delta_count() << std::endl;
    //Connection to Dummies
    MasterDummy masterDummy("masterDummy");

    SlaveDummy slaveDummy0("slaveDummy0");
    SlaveDummy slaveDummy1("slaveDummy1");
    SlaveDummy slaveDummy2("slaveDummy2");
    SlaveDummy slaveDummy3("slaveDummy3");

    Blocking<bus_req_t> MasterDummyToMasterAgent("MasterDummyToMasterAgent");
    masterAgent.master_to_agent(MasterDummyToMasterAgent);
    masterDummy.bus_req(MasterDummyToMasterAgent);
    Blocking<bus_resp_t> MasterAgenToMasterDummy("MasterAgenToMasterDummy");
    masterAgent.agent_to_master(MasterAgenToMasterDummy);
    masterDummy.bus_resp(MasterAgenToMasterDummy);


    Blocking<bus_req_t> SlaveDummyToSlaveAgent0("SlaveDummyToSlaveAgent0");
    slaveAgent0.agent_to_slave(SlaveDummyToSlaveAgent0);
    slaveDummy0.bus_req(SlaveDummyToSlaveAgent0);
    Blocking<bus_resp_t> SlaveAgenToSlaveDummy0("SlaveAgenToSlaveDummy0");
    slaveAgent0.slave_to_agent(SlaveAgenToSlaveDummy0);
    slaveDummy0.bus_resp(SlaveAgenToSlaveDummy0);



    Blocking<bus_req_t> SlaveDummyToSlaveAgent1("SlaveDummyToSlaveAgent1");
    slaveAgent1.agent_to_slave(SlaveDummyToSlaveAgent1);
    slaveDummy1.bus_req(SlaveDummyToSlaveAgent1);
    Blocking<bus_resp_t> SlaveAgenToSlaveDummy1("SlaveAgenToSlaveDummy1");
    slaveAgent1.slave_to_agent(SlaveAgenToSlaveDummy1);
    slaveDummy1.bus_resp(SlaveAgenToSlaveDummy1);

    Blocking<bus_req_t> SlaveDummyToSlaveAgent2("SlaveDummyToSlaveAgent2");
    slaveAgent2.agent_to_slave(SlaveDummyToSlaveAgent2);
    slaveDummy2.bus_req(SlaveDummyToSlaveAgent2);
    Blocking<bus_resp_t> SlaveAgenToSlaveDummy2("SlaveAgenToSlaveDummy2");
    slaveAgent2.slave_to_agent(SlaveAgenToSlaveDummy2);
    slaveDummy2.bus_resp(SlaveAgenToSlaveDummy2);



    Blocking<bus_req_t> SlaveDummyToSlaveAgent3("SlaveDummyToSlaveAgent3");
    slaveAgent3.agent_to_slave(SlaveDummyToSlaveAgent3);
    slaveDummy3.bus_req(SlaveDummyToSlaveAgent3);
    Blocking<bus_resp_t> SlaveAgenToSlaveDummy3("SlaveAgenToSlaveDummy3");
    slaveAgent3.slave_to_agent(SlaveAgenToSlaveDummy3);
    slaveDummy3.bus_resp(SlaveAgenToSlaveDummy3);
    


    sc_start();

    return 0;
}

