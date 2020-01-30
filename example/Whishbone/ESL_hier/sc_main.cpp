#include "systemc.h"
#include "MasterAgent.h"
#include "SlaveAgent.h"
#include "Interconnect.h"
#include "SlaveDummy.h"
#include "MasterDummy.h"
#include "Bus_structure.h"

using namespace std;

int sc_main(int, char **) {

//
//    //std::cout << sc_delta_count() << std::endl;
//    //Connection to Dummies
//    MasterDummy masterDummy("masterDummy");
//
//    SlaveDummy slaveDummy0("slaveDummy0");
//    SlaveDummy slaveDummy1("slaveDummy1");
//    SlaveDummy slaveDummy2("slaveDummy2");
//    SlaveDummy slaveDummy3("slaveDummy3");
//
//    Blocking<bus_req_t> MasterDummyToMasterAgent("MasterDummyToMasterAgent");
//    masterAgent.master_to_agent(MasterDummyToMasterAgent);
//    masterDummy.bus_req(MasterDummyToMasterAgent);
//    Blocking<bus_resp_t> MasterAgenToMasterDummy("MasterAgenToMasterDummy");
//    masterAgent.agent_to_master(MasterAgenToMasterDummy);
//    masterDummy.bus_resp(MasterAgenToMasterDummy);
//
//
//    Blocking<bus_req_t> SlaveDummyToSlaveAgent0("SlaveDummyToSlaveAgent0");
//    slaveAgent0.agent_to_slave(SlaveDummyToSlaveAgent0);
//    slaveDummy0.bus_req(SlaveDummyToSlaveAgent0);
//    Blocking<bus_resp_t> SlaveAgenToSlaveDummy0("SlaveAgenToSlaveDummy0");
//    slaveAgent0.slave_to_agent(SlaveAgenToSlaveDummy0);
//    slaveDummy0.bus_resp(SlaveAgenToSlaveDummy0);
//
//
//
//    Blocking<bus_req_t> SlaveDummyToSlaveAgent1("SlaveDummyToSlaveAgent1");
//    slaveAgent1.agent_to_slave(SlaveDummyToSlaveAgent1);
//    slaveDummy1.bus_req(SlaveDummyToSlaveAgent1);
//    Blocking<bus_resp_t> SlaveAgenToSlaveDummy1("SlaveAgenToSlaveDummy1");
//    slaveAgent1.slave_to_agent(SlaveAgenToSlaveDummy1);
//    slaveDummy1.bus_resp(SlaveAgenToSlaveDummy1);
//
//    Blocking<bus_req_t> SlaveDummyToSlaveAgent2("SlaveDummyToSlaveAgent2");
//    slaveAgent2.agent_to_slave(SlaveDummyToSlaveAgent2);
//    slaveDummy2.bus_req(SlaveDummyToSlaveAgent2);
//    Blocking<bus_resp_t> SlaveAgenToSlaveDummy2("SlaveAgenToSlaveDummy2");
//    slaveAgent2.slave_to_agent(SlaveAgenToSlaveDummy2);
//    slaveDummy2.bus_resp(SlaveAgenToSlaveDummy2);
//
//
//
//    Blocking<bus_req_t> SlaveDummyToSlaveAgent3("SlaveDummyToSlaveAgent3");
//    slaveAgent3.agent_to_slave(SlaveDummyToSlaveAgent3);
//    slaveDummy3.bus_req(SlaveDummyToSlaveAgent3);
//    Blocking<bus_resp_t> SlaveAgenToSlaveDummy3("SlaveAgenToSlaveDummy3");
//    slaveAgent3.slave_to_agent(SlaveAgenToSlaveDummy3);
//    slaveDummy3.bus_resp(SlaveAgenToSlaveDummy3);
//


    sc_start();

    return 0;
}

