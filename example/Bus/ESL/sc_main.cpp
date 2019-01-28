#include <Blocking.h>
#include "systemc.h"
#include "Bus.h"
#include "SlaveDummy.h"
#include "MasterDummy.h"
#include "../../SingleMasterMultiSlave/ESL/Compound.h"


using namespace std;

int sc_main(int, char **) {



    //std::cout << sc_delta_count() << std::endl;
    //Connection to Dummies
    MasterDummy masterDummy("masterDummy");

    SlaveDummy slaveDummy0("slaveDummy0");
    SlaveDummy slaveDummy1("slaveDummy1");
    SlaveDummy slaveDummy2("slaveDummy2");
    SlaveDummy slaveDummy3("slaveDummy3");

    Bus bus("bus");

    Blocking<bus_req_t> MasterToBus("MasterToBus");
    masterDummy.bus_req(MasterToBus);
    bus.master_in(MasterToBus);
    Blocking<bus_resp_t> MasterAgenToMasterDummy("BusToMaster");
    bus.master_out(MasterAgenToMasterDummy);
    masterDummy.bus_resp(MasterAgenToMasterDummy);


    Blocking<bus_req_t> BusToSlaveDummy0("BusToSlaveDummy0");
    slaveDummy0.bus_req(BusToSlaveDummy0);
    bus.slave_out0(BusToSlaveDummy0);
    Blocking<bus_resp_t> SlaveDummyToBus0("SlaveDummyToBus0");
    bus.slave_in0(SlaveDummyToBus0);
    slaveDummy0.bus_resp(SlaveDummyToBus0);


    Blocking<bus_req_t> BusToSlaveDummy1("BusToSlaveDummy1");
    slaveDummy1.bus_req(BusToSlaveDummy1);
    bus.slave_out1(BusToSlaveDummy1);
    Blocking<bus_resp_t> SlaveDummyToBus1("SlaveDummyToBus1");
    bus.slave_in1(SlaveDummyToBus1);
    slaveDummy1.bus_resp(SlaveDummyToBus1);


    Blocking<bus_req_t> BusToSlaveDummy2("BusToSlaveDummy2");
    slaveDummy2.bus_req(BusToSlaveDummy2);
    bus.slave_out2(BusToSlaveDummy2);
    Blocking<bus_resp_t> SlaveDummyToBus2("SlaveDummyToBus2");
    bus.slave_in2(SlaveDummyToBus2);
    slaveDummy2.bus_resp(SlaveDummyToBus2);


    Blocking<bus_req_t> BusToSlaveDummy3("BusToSlaveDummy3");
    slaveDummy3.bus_req(BusToSlaveDummy3);
    bus.slave_out3(BusToSlaveDummy3);
    Blocking<bus_resp_t> SlaveDummyToBus3("SlaveDummyToBus3");
    bus.slave_in3(SlaveDummyToBus3);
    slaveDummy3.bus_resp(SlaveDummyToBus3);
    

    sc_start();

    return 0;
}

