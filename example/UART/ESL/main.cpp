#include <iostream>


#include "systemc.h"

#include "Blocking.h"

#include "Bus.h"
#include "UART.h"
#include "MasterDummy.h"

#include "ExternalDummy.h"

using namespace std;

int sc_main(int, char **) {


    MasterDummy masterDummy("masterDummy");

    UART uart1("uart1");
    ExternalDummy ext("ext");



    Bus bus1("bus1");

    Blocking<CUtoME_IF> MasterToBus("MasterToBus");
    bus1.master_in(MasterToBus);
    masterDummy.bus_req(MasterToBus);

    Blocking<MEtoCU_IF> BusToMaster("BusToMaster");
    bus1.master_out(BusToMaster);
    masterDummy.bus_resp(BusToMaster);


    Blocking<CUtoME_IF> Bus_to_Uart1("Bus_to_Uart1");
    bus1.slave_out0(Bus_to_Uart1);
    uart1.request(Bus_to_Uart1);


    Blocking<MEtoCU_IF> Uart1_to_Bus("Uart1_to_Bus");
    bus1.slave_in0(Uart1_to_Bus);
    uart1.response(Uart1_to_Bus);


    MasterSlave<bool> uart1_it("uart1_it");
    uart1.interrupt(uart1_it);
    masterDummy.uart1_interrupt(uart1_it);



    MasterSlave<unsigned int> uart_to_ext("uart_to_ext");

    MasterSlave<unsigned int> ext_to_uart("ext_to_uart");
    uart1.tx(uart_to_ext);
    ext.rx_pin(uart_to_ext);
    uart1.rx(ext_to_uart);
    ext.tx_pin(ext_to_uart);






    sc_start();

    return 0;
}