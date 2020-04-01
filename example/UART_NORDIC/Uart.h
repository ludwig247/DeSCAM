 #ifndef UART_H_
#define UART_H_

#include "systemc.h"
#include "Interfaces.h"
#include "Uart_types.h"
#include "Uart_control.h"
#include "Uart_tx.h"
#include "Uart_rx.h"


SC_MODULE(Uart)
{
    slave_in<bus_req_t>        bus_in;
    slave_out<bus_resp_t>      bus_out;
    slave_in<tasks_t>          tasks_in;
    master_out<events_t>       events_out;
    slave_in<bool>             cts_in;
    master_out<bool>           rts_out;

    MasterSlave<tx_control_in_t>  control_from_tx;
    MasterSlave<tx_control_out_t> control_to_tx;
    MasterSlave<rx_control_in_t>  control_from_rx;
    MasterSlave<rx_control_out_t> control_to_rx;
    MasterSlave<config_t>         config_to_tx;
    MasterSlave<config_t>         config_to_rx;

    blocking_in<unsigned int>  tx_data_in;
    blocking_out<unsigned int> rx_data_out;
    blocking_out<bool> txd;
    blocking_in<bool>  rxd;


    Uart_control uart_control;
    Uart_tx uart_tx;
    Uart_rx uart_rx;

    SC_CTOR(Uart):
    control_from_tx("control_in_tx"),
    control_to_tx("control_out_tx"),
    control_from_rx("control_in_rx"),
    control_to_rx("control_out_rx"),
    config_to_tx("config_to_tx"),
    config_to_rx("config_to_rx"),
    uart_control("uart_control"),
    uart_tx("uart_tx"),
    uart_rx("uart_rx")
    {
        uart_control.bus_in(bus_in);
        uart_control.bus_out(bus_out);
        uart_control.tasks_in(tasks_in);
        uart_control.events_out(events_out);
        uart_control.tx_control_out(control_to_tx);
        uart_control.tx_control_in(control_from_tx);
        uart_control.rx_control_out(control_to_rx);
        uart_control.rx_control_in(control_from_rx);
        uart_control.tx_config_out(config_to_tx);
        uart_control.rx_config_out(config_to_rx);
        uart_control.cts_in(cts_in);
        uart_control.rts_out(rts_out);

        uart_tx.data_in(tx_data_in);
        uart_tx.txd(txd);
        uart_tx.control_in(control_to_tx);
        uart_tx.control_out(control_from_tx);
        uart_tx.config_in(config_to_tx);

        uart_rx.data_out(rx_data_out);
        uart_rx.rxd(rxd);
        uart_rx.control_in(control_to_rx);
        uart_rx.control_out(control_from_rx);
        uart_rx.config_in(config_to_rx);
    }

};

#endif