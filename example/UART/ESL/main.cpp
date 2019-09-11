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

using namespace std;

int sc_main(int, char **) {

//    //std::cout << sc_delta_count() << std::endl;
//    //Connection to Dummies
//    MasterDummy masterDummy("masterDummy");
//
//    UART uart1("uart1");
//    UART uart2("uart2");
//    Bus bus1("bus1");
//
//
//    Blocking<CUtoME_IF> MasterToBus("MasterToBus");
//    bus1.master_in(MasterToBus);
//    masterDummy.bus_req(MasterToBus);
//
//    Blocking<MEtoCU_IF> BusToMaster("BusToMaster");
//    bus1.master_out(BusToMaster);
//    masterDummy.bus_resp(BusToMaster);
//
//    Blocking<CUtoME_IF> Bus_to_Uart1("Bus_to_Uart1");
//    bus1.slave_out0(Bus_to_Uart1);
//    uart1.uart_in(Bus_to_Uart1);
//
//    Blocking<CUtoME_IF> Bus_to_Uart2("Bus_to_Uart2");
//    bus1.slave_out1(Bus_to_Uart2);
//    uart2.uart_in(Bus_to_Uart2);
//
//    Blocking<MEtoCU_IF> Uart1_to_Bus("Uart1_to_Bus");
//    bus1.slave_in0(Uart1_to_Bus);
//    uart1.uart_out(Uart1_to_Bus);
//
//    Blocking<MEtoCU_IF> Uart2_to_Bus("Uart2_to_Bus");
//    bus1.slave_in1(Uart2_to_Bus);
//    uart2.uart_out(Uart2_to_Bus);
//
//    Shared<bool> uart1_to_uart2("uart1_to_uart2");
//    uart1.tx(uart1_to_uart2);
//    uart2.rx(uart1_to_uart2);
//
//    Shared<bool> uart2_to_uart1("uart2_to_uart1");
//    uart2.tx(uart2_to_uart1);
//    uart1.rx(uart2_to_uart1);
//
//    MasterSlave<bool> uart1_it("uart1_it");
//    uart1.interrupt_enabled(uart1_it);
//    masterDummy.uart1_interrupt(uart1_it);
//
//    MasterSlave<bool> uart2_it("uart2_it");
//    uart2.interrupt_enabled(uart2_it);
//    masterDummy.uart2_interrupt(uart2_it);
//


    MasterDummy masterDummy("masterDummy");
    Arbiter arbiter("arbiter");

    UART uart1("uart1");
    UART uart2("uart2");
    UART uart3("uart3");
    UART uart4("uart4");
    UART uart5("uart5");
    Bus bus1("bus1");

    baudgen baudmakerbaker("baudmakerbaker");

    //MASTER
    Blocking<CUtoME_IF> MasterToBus("MasterToBus");
    bus1.master_in(MasterToBus);
    masterDummy.bus_req(MasterToBus);

    Blocking<MEtoCU_IF> BusToMaster("BusToMaster");
    bus1.master_out(BusToMaster);
    masterDummy.bus_resp(BusToMaster);


    //UART 1
    MasterSlave<bool> uart1_it("uart1_it");
    Blocking<CUtoME_IF> Bus_to_Uart1("Bus_to_Uart1");
    Blocking<MEtoCU_IF> Uart1_to_Bus("Uart1_to_Bus");
    bus1.slave_out0(Bus_to_Uart1);
    uart1.uart_in(Bus_to_Uart1);
    bus1.slave_in0(Uart1_to_Bus);
    uart1.uart_out(Uart1_to_Bus);
    uart1.interrupt_enabled(uart1_it);
    masterDummy.uart1_interrupt(uart1_it);

    //UART 2
    MasterSlave<bool> uart2_it("uart2_it");
    Blocking<CUtoME_IF> Bus_to_Uart2("Bus_to_Uart2");
    Blocking<MEtoCU_IF> Uart2_to_Bus("Uart2_to_Bus");
    bus1.slave_out1(Bus_to_Uart2);
    uart2.uart_in(Bus_to_Uart2);
    bus1.slave_in1(Uart2_to_Bus);
    uart2.uart_out(Uart2_to_Bus);
    uart2.interrupt_enabled(uart2_it);
    masterDummy.uart2_interrupt(uart2_it);

    //UART 3
    MasterSlave<bool> uart3_it("uart3_it");
    Blocking<CUtoME_IF> Bus_to_Uart3("Bus_to_Uart3");
    Blocking<MEtoCU_IF> Uart3_to_Bus("Uart3_to_Bus");
    bus1.slave_out2(Bus_to_Uart3);
    uart3.uart_in(Bus_to_Uart3);
    bus1.slave_in2(Uart3_to_Bus);
    uart3.uart_out(Uart3_to_Bus);
    uart3.interrupt_enabled(uart3_it);
    masterDummy.uart3_interrupt(uart3_it);

    //UART 4
    MasterSlave<bool> uart4_it("uart4_it");
    Blocking<CUtoME_IF> Bus_to_Uart4("Bus_to_Uart4");
    Blocking<MEtoCU_IF> Uart4_to_Bus("Uart4_to_Bus");
    bus1.slave_out3(Bus_to_Uart4);
    uart4.uart_in(Bus_to_Uart4);
    bus1.slave_in3(Uart4_to_Bus);
    uart4.uart_out(Uart4_to_Bus);
    uart4.interrupt_enabled(uart4_it);
    masterDummy.uart4_interrupt(uart4_it);

    //UART 5
    MasterSlave<bool> uart5_it("uart5_it");
    Blocking<CUtoME_IF> Bus_to_Uart5("Bus_to_Uart5");
    Blocking<MEtoCU_IF> Uart5_to_Bus("Uart5_to_Bus");
    bus1.slave_out4(Bus_to_Uart5);
    uart5.uart_in(Bus_to_Uart5);
    bus1.slave_in4(Uart5_to_Bus);
    uart5.uart_out(Uart5_to_Bus);
    uart5.interrupt_enabled(uart5_it);
    masterDummy.uart5_interrupt(uart5_it);


    Shared<bool> uart1_tx("uart1_tx");
    Shared<bool> uart2_tx("uart2_tx");
    Shared<bool> uart3_tx("uart3_tx");
    Shared<bool> uart4_tx("uart4_tx");
    Shared<bool> uart5_tx("uart5_tx");
    uart1.tx(uart1_tx);
    uart2.tx(uart2_tx);
    uart3.tx(uart3_tx);
    uart4.tx(uart4_tx);
    uart5.tx(uart5_tx);
    arbiter.Uart1_Tx(uart1_tx);
    arbiter.Uart2_Tx(uart2_tx);
    arbiter.Uart3_Tx(uart3_tx);
    arbiter.Uart4_Tx(uart4_tx);
    arbiter.Uart5_Tx(uart5_tx);


    Shared<bool> uart1_rx("uart1_rx");
    Shared<bool> uart2_rx("uart2_rx");
    Shared<bool> uart3_rx("uart3_rx");
    Shared<bool> uart4_rx("uart4_rx");
    Shared<bool> uart5_rx("uart5_rx");
    uart1.rx(uart1_rx);
    uart2.rx(uart2_rx);
    uart3.rx(uart3_rx);
    uart4.rx(uart4_rx);
    uart5.rx(uart5_rx);
    arbiter.Uart1_Rx(uart1_rx);
    arbiter.Uart2_Rx(uart2_rx);
    arbiter.Uart3_Rx(uart3_rx);
    arbiter.Uart4_Rx(uart4_rx);
    arbiter.Uart5_Rx(uart5_rx);

    MasterSlave<bool> trigger1("trigger1");
    MasterSlave<bool> trigger2("trigger2");
    arbiter.trigg1(trigger1);
    arbiter.trigg2(trigger2);
    baudmakerbaker.trans_trigger(trigger1);
    baudmakerbaker.rec_trigger(trigger2);

    sc_start();

    return 0;
}