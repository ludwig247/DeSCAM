#include "systemc.h"
#include "Bus_structure.h"
#include "MasterDummy.h"
#include "SlaveDummy.h"

using namespace std;

int sc_main(int, char **) {

    Bus_structure bus("bus");

	
    MasterDummy masterDummy("masterDummy");

    SlaveDummy slaveDummy0("slaveDummy0");
    SlaveDummy slaveDummy1("slaveDummy1");
    SlaveDummy slaveDummy2("slaveDummy2");
    SlaveDummy slaveDummy3("slaveDummy3");

    Blocking<bus_req_t> MasterDummyToMasterAgent("MasterDummyToMasterAgent");
    bus.MasterAgenToOutside_port(MasterDummyToMasterAgent);
    masterDummy.bus_req(MasterDummyToMasterAgent);
    Blocking<bus_resp_t> MasterAgenToMasterDummy("MasterAgenToMasterDummy");
    bus.OutsideToMasterAgent_port(MasterAgenToMasterDummy);
    masterDummy.bus_resp(MasterAgenToMasterDummy);


    Blocking<bus_req_t> SlaveDummyToSlaveAgent0("SlaveDummyToSlaveAgent0");
    bus.SlaveToOutside0_port(SlaveDummyToSlaveAgent0);
    slaveDummy0.bus_req(SlaveDummyToSlaveAgent0);
    Blocking<bus_resp_t> SlaveAgenToSlaveDummy0("SlaveAgenToSlaveDummy0");
    bus.OutsideToSlave0_port(SlaveAgenToSlaveDummy0);
    slaveDummy0.bus_resp(SlaveAgenToSlaveDummy0);



    Blocking<bus_req_t> SlaveDummyToSlaveAgent1("SlaveDummyToSlaveAgent1");
    bus.SlaveToOutside1_port(SlaveDummyToSlaveAgent1);
    slaveDummy1.bus_req(SlaveDummyToSlaveAgent1);
    Blocking<bus_resp_t> SlaveAgenToSlaveDummy1("SlaveAgenToSlaveDummy1");
    bus.OutsideToSlave1_port(SlaveAgenToSlaveDummy1);
    slaveDummy1.bus_resp(SlaveAgenToSlaveDummy1);

    Blocking<bus_req_t> SlaveDummyToSlaveAgent2("SlaveDummyToSlaveAgent2");
    bus.SlaveToOutside2_port(SlaveDummyToSlaveAgent2);
    slaveDummy2.bus_req(SlaveDummyToSlaveAgent2);
    Blocking<bus_resp_t> SlaveAgenToSlaveDummy2("SlaveAgenToSlaveDummy2");
    bus.OutsideToSlave2_port(SlaveAgenToSlaveDummy2);
    slaveDummy2.bus_resp(SlaveAgenToSlaveDummy2);



    Blocking<bus_req_t> SlaveDummyToSlaveAgent3("SlaveDummyToSlaveAgent3");
    bus.SlaveToOutside3_port(SlaveDummyToSlaveAgent3);
    slaveDummy3.bus_req(SlaveDummyToSlaveAgent3);
    Blocking<bus_resp_t> SlaveAgenToSlaveDummy3("SlaveAgenToSlaveDummy3");
    bus.OutsideToSlave3_port(SlaveAgenToSlaveDummy3);
    slaveDummy3.bus_resp(SlaveAgenToSlaveDummy3);

    sc_start();

    return 0;
}

