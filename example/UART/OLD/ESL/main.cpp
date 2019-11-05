//
// Created by ovsthus on 11/28/18.
//

#include "Blocking.h"
#include "Shared.h"
#include "systemc.h"
#include "Bus.h"
#include "UART.h"
#include "MasterDummy.h"
#include "Arbiter.h"
#include "baudgen.h"
#include "ExternalDummy.h"

using namespace std;

int sc_main(int, char **) {

//    //std::cout << sc_delta_count() << std::endl;
//    //Connection to Dummies
    MasterDummy masterDummy("masterDummy");

    UART uart1("uart1");
    ExternalDummy ext("ext");

//    UART uart2("uart2");
//
    Bus bus1("bus1");
//
    Blocking<CUtoME_IF> MasterToBus("MasterToBus");
    bus1.master_in(MasterToBus);
    masterDummy.bus_req(MasterToBus);
//
    Blocking<MEtoCU_IF> BusToMaster("BusToMaster");
    bus1.master_out(BusToMaster);
    masterDummy.bus_resp(BusToMaster);
//
    Blocking<CUtoME_IF> Bus_to_Uart1("Bus_to_Uart1");
    bus1.slave_out0(Bus_to_Uart1);
    uart1.request(Bus_to_Uart1);
//
//    Blocking<CUtoME_IF> Bus_to_Uart2("Bus_to_Uart2");
//    bus1.slave_out1(Bus_to_Uart2);
//    uart2.request(Bus_to_Uart2);
//
    Blocking<MEtoCU_IF> Uart1_to_Bus("Uart1_to_Bus");
    bus1.slave_in0(Uart1_to_Bus);
    uart1.response(Uart1_to_Bus);
//
//    Blocking<MEtoCU_IF> Uart2_to_Bus("Uart2_to_Bus");
//    bus1.slave_in1(Uart2_to_Bus);
//    uart2.response(Uart2_to_Bus);
//
//    Shared<bool> uart1_to_uart2("uart1_to_uart2");
//    uart1.tx(uart1_to_uart2);
//    uart2.rx(uart1_to_uart2);
//
//    Shared<bool> uart2_to_uart1("uart2_to_uart1");
//    uart2.tx(uart2_to_uart1);
//    uart1.rx(uart2_to_uart1);
//
    MasterSlave<bool> uart1_it("uart1_it");
    uart1.interrupt(uart1_it);
    masterDummy.uart1_interrupt(uart1_it);

//    MasterSlave<bool> uart2_it("uart2_it");
//    uart2.interrupt(uart2_it);
//    masterDummy.uart2_interrupt(uart2_it);

MasterSlave<bool> uart_to_ext("uart_to_ext");

MasterSlave<bool> ext_to_uart("ext_to_uart");
uart1.tx(uart_to_ext);
ext.rx_pin(uart_to_ext);
uart1.rx(ext_to_uart);
ext.tx_pin(ext_to_uart);






    sc_start();

    return 0;
}