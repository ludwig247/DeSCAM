
#include "systemc.h"
#include "Uart.h"
#include "Interfaces.h"
#include "Stimuli.h"
#include "Uart_types.h"

int sc_main(int, char **)
{
    MasterSlave<bus_req_t> uart_bus_in("uart_in");
    MasterSlave<bus_resp_t> uart_bus_out("uart_out");
    Blocking<unsigned int> uart_data_in("uart_data_in");
    Blocking<bool> uart_txd("uart_txd");
    Blocking<unsigned int> uart_data_out("uart_data_out");
    Blocking<bool> uart_rxd("uart_rxd");
    Shared<tasks_t> uart_tasks("uart_tasks");
    Shared<events_t> uart_events("uart_events");
    Shared<bool> uart_cts_in("uart_cts_in");
    Shared<bool> uart_rts_out("uart_rts_out");
    
    
    Uart uart("Uart");
    Stimuli stimuli("stimuli");

    uart.bus_in(uart_bus_in);
    uart.bus_out(uart_bus_out);
    uart.tasks_in(uart_tasks);
    uart.events_out(uart_events);
    uart.tx_data_in(uart_data_in);
    uart.rxd(uart_rxd);
    uart.rx_data_out(uart_data_out);
    uart.txd(uart_txd);
    uart.cts_in(uart_cts_in);
    uart.rts_out(uart_rts_out);
    stimuli.bus_out(uart_bus_in);
    stimuli.bus_in(uart_bus_out);
    stimuli.tasks_out(uart_tasks);
    stimuli.events_in(uart_events);
    stimuli.data_out(uart_data_in);
    stimuli.txd(uart_txd);
    stimuli.data_in(uart_data_out);
    stimuli.rxd(uart_rxd);
    stimuli.cts_out(uart_cts_in);
    stimuli.rts_in(uart_rts_out);


    sc_start();


    return 0;
}