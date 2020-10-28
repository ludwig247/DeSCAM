#include "systemc.h"
#include "../../Interfaces/Interfaces.h"
#include "Uart_types.h"

SC_MODULE(Uart_rx)
{

    blocking_in<bool>  rxd;

    master_out<rx_events_t> events_out;

    rx_events_t  events_out_msg;
    bool         rx_bit;

    SC_CTOR(Uart_rx):
        rxd("rxd"),
        events_out("events_out"),
        rx_bit(false)
    {
        SC_THREAD(fsm);
    }

    void fsm()
    {

        events_out_msg.timeout    = false;
        events_out_msg.ready      = false;
        events_out_msg.error_src  = 0;

        while(true)
        {
            rxd->read(rx_bit, "IDLE");

            if (rx_bit == false) {

                // DeSCAM does not take into account that rx_bit gets a new value here
                rxd->read(rx_bit, "GET_STOP_BIT");

                // Therefore, it assumes that rx_bit is still false and evaluates the if condition to always true
                if (rx_bit == false) {
                    events_out_msg.error_src = ERROR_FRAMING_MASK;
                }

                events_out_msg.ready = true;
                events_out->master_write(events_out_msg, "EVENT_READY");

                events_out_msg.ready = false;
                events_out_msg.error_src = 0;

            }
        }
    }

};
