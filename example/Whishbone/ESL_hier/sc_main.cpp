#include "systemc.h"
#include "SlaveDummy.h"
#include "MasterDummy.h"
#include "Bus_structure.h"

using namespace std;

int sc_main(int, char **) {
    SlaveDummy slaveDummy0("slaveDummy0");
    SlaveDummy slaveDummy1("slaveDummy1");
    SlaveDummy slaveDummy2("slaveDummy2");
    SlaveDummy slaveDummy3("slaveDummy3");

    Bus_structure bus("bus");
    MasterDummy masterDummy("masterDummy");

    masterDummy.bus_req(bus.MasterAgenToOutside);
    masterDummy.bus_resp(bus.OutsideToMasterAgent);

    slaveDummy0.bus_req(bus.SlaveToOutside0);
    slaveDummy0.bus_resp(bus.OutsideToSlave0);

    slaveDummy1.bus_req(bus.SlaveToOutside1);
    slaveDummy1.bus_resp(bus.OutsideToSlave1);

    slaveDummy2.bus_req(bus.SlaveToOutside2);
    slaveDummy2.bus_resp(bus.OutsideToSlave2);

    slaveDummy3.bus_req(bus.SlaveToOutside3);
    slaveDummy3.bus_resp(bus.OutsideToSlave3);



    sc_start();

    return 0;
}

