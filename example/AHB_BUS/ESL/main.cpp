#include <iostream>
#include "systemc.h"
#include "Interfaces.h"

//#include "AHB_bus.h"
//#include "Mdummy.h"
//#include "Sdummy.h"
#include "AHB_Bus_Channel.h"
#include "Master.h"
#include "Slave.h"
#include "Initializer_Dummy.h"

int sc_main(int, char **)  {
//    Mdummy m0("master_0");
//    Mdummy m1("master_1");
//    Mdummy m2("master_2");
//    Mdummy m3("master_3");
//
//    Sdummy s0("slave_0");
//
//    AHB bus("bus");
//
//    //MasterDummy to bus Connections
//    Blocking<bus_req_t> MasterRequest0("MasterRequest0");
//    m0.master_out(MasterRequest0);
//    bus.master0_in(MasterRequest0);
//    Blocking<bus_req_t> MasterRequest1("MasterRequest1");
//    m1.master_out(MasterRequest1);
//    bus.master1_in(MasterRequest1);
//    Blocking<bus_req_t> MasterRequest2("MasterRequest2");
//    m2.master_out(MasterRequest2);
//    bus.master2_in(MasterRequest2);
//    Blocking<bus_req_t> MasterRequest3("MasterRequest3");
//    m3.master_out(MasterRequest3);
//    bus.master3_in(MasterRequest3);
//    Blocking<bus_resp_t> MasterResponse0("MasterResponse0");
//    m0.master_in(MasterResponse0);
//    bus.master0_out(MasterResponse0);
//    Blocking<bus_resp_t> MasterResponse1("MasterResponse1");
//    m1.master_in(MasterResponse1);
//    bus.master1_out(MasterResponse1);
//    Blocking<bus_resp_t> MasterResponse2("MasterResponse2");
//    m2.master_in(MasterResponse2);
//    bus.master2_out(MasterResponse2);
//    Blocking<bus_resp_t> MasterResponse3("MasterResponse3");
//    m3.master_in(MasterResponse3);
//    bus.master3_out(MasterResponse3);
//
//
//    //SlaveDummy connection
//    Blocking<bus_req_t> SlaveRequest0("SlaveRequest0");
//    s0.slave_in(SlaveRequest0);
//    bus.slave0_out(SlaveRequest0);
//
//    Blocking<bus_resp_t> SlaveResponse0("SlaveResponse0");
//    s0.slave_out(SlaveResponse0);
//    bus.slave0_in(SlaveResponse0);

    AHB_Bus_Channel Bus ("Bus");
    Master M0("Master0");
    Master M1("Master1");
//    Master M2("Master2");
//    Master M3("Master3");
    Slave S0("Slave0");
    Slave S1("Slave1");
//    Slave S2("Slave2");
//    Slave S3("Slave3");
    Initializer_Dummy I("Initializer");
//    M0.master_out.bind(Bus);
//    M0.master_in.bind(Bus);
//    M1.master_out.bind(Bus);
//    M1.master_in.bind(Bus);
    M0.master_if.bind(Bus);
    M1.master_if.bind(Bus);
//    M2.master_out.bind(Bus);
//    M2.master_in.bind(Bus);
//    M3.master_out.bind(Bus);
//    M3.master_in.bind(Bus);
    S0.slave_out.bind(Bus);
    S0.slave_in.bind(Bus);
    S1.slave_out.bind(Bus);
    S1.slave_in.bind(Bus);
//    S2.slave_out.bind(Bus);
//    S2.slave_in.bind(Bus);
//    S3.slave_out.bind(Bus);
//    S3.slave_in.bind(Bus);
    I.init_out.bind(Bus);
    sc_start(10,SC_PS);
    return 0;
}