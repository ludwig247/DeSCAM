
#include "systemc.h"
#include "Interfaces.h"
#include "Uart_types.h"



SC_MODULE(Uart_rx)
{
    //blocking_out<unsigned int> data_out;
    shared_out<data_t> data_out;
    shared_in<bool> data_out_sync;
    blocking_in<bool> rxd; // syncs with the baud rate clock

    shared_in<bool> control_active_in;
    shared_in<config_t> config_in;
    master_out<rx_events_t> events_out;

    data_t           data_out_msg;
    rx_events_t      events_out_msg;
    config_t         config_in_msg;
    bool             control_active_in_msg;

    bool             success_rxd;
    bool             data_out_sync_msg;

    bool             rx_bit;
    unsigned int     data;
    unsigned int     suspending_count;
    bool             timeout;

    bool parity;
    bool first_stop_bit;

    bool wait_framing_break;

    SC_CTOR(Uart_rx):
        data_out("data_out"),
        rxd("rxd"),
        control_active_in("control_in"),
        events_out("events_out"),
        config_in("config_in"),
        success_rxd(false),
        timeout(true),
        data(0),
        parity(false),
        first_stop_bit(false),
        suspending_count(0),
        rx_bit(false),
        data_out_sync_msg(false),
        wait_framing_break(false)
    {
        SC_THREAD(fsm);
    }

    void fsm()
    {
        // Events "reset"
        events_out_msg.timeout       = false;
        events_out_msg.ready         = false;
        events_out_msg.error_src     = 0;
        data_out_msg.valid           = false;
        timeout                      = true;
        while(true)
        {
            
            rxd->try_read(rx_bit, success_rxd, "IDLE"); // Always check for new incoming rxd bits
            control_active_in->get(control_active_in_msg);       
            
            if (!timeout || control_active_in_msg)
            {
                timeout = false;
                suspending_count = control_active_in_msg ? 0 : suspending_count;
                //if (success_rxd) std::cout << "##### RX: got a bit! Not timeout. Active: " << control_active_in_msg << std::endl;
                // Data read handshake
                data_out_sync->get(data_out_sync_msg);
                if (data_out_sync_msg) 
                {
                    data_out_msg.valid = false;
                    data_out->set(data_out_msg);
                }

                if (!success_rxd)
                {
                    if (!control_active_in_msg && suspending_count >= UART_TIMEOUT)
                    {
#ifdef SIM
                        debug_print(RX, "EVENT TIMEOUT");
#endif
                        events_out_msg.timeout = true;
                        events_out->master_write(events_out_msg, "ERROR_TIMEOUT");
                        events_out_msg.timeout = false;
                        //suspending_count = 0;
                        timeout = true;
                    }
                    //else if (control_active_in_msg) suspending_count = 0;
                }
                else
                {
                    if (!control_active_in_msg)
                    {
#ifdef SIM
                        debug_print(RX, "Waiting for TIMEOUT: " + std::to_string(suspending_count));
#endif
                        suspending_count = ((rx_bit == START_BIT) && !wait_framing_break) ? suspending_count + 11 : suspending_count + 1;
                    }
                    // else
                    // {
                    //     suspending_count = 0;
                    // }
                    
                    // Make sure we get a STOP_BIT before continuing, in case of a break cond.
                    wait_framing_break = (rx_bit == STOP_BIT) ? false : wait_framing_break;
                    if (!wait_framing_break && (rx_bit == START_BIT))
                    {   
                        if (data_out_msg.valid)
                        {
#ifdef SIM
                            debug_print(RX, "ERROR OVERRUN");
#endif
                            events_out_msg.error_src = ERROR_OVERRUN_MASK;
                            events_out->master_write(events_out_msg, "ERROR_OVERRUN");
                            events_out_msg.error_src = 0;
                        }
                        data_out_msg.valid = false;
                        data_out->set(data_out_msg);

                        rxd->read(rx_bit, "GET_BIT_ZERO");
                        data_out_msg.data = update_data(rx_bit, data_out_msg.data, 0);
                        data_out->set(data_out_msg);
                        rxd->read(rx_bit, "GET_BIT_ONE");
                        data_out_msg.data = update_data(rx_bit, data_out_msg.data, 1);
                        data_out->set(data_out_msg);
                        rxd->read(rx_bit, "GET_BIT_TWO");
                        data_out_msg.data = update_data(rx_bit, data_out_msg.data, 2);
                        data_out->set(data_out_msg);
                        rxd->read(rx_bit, "GET_BIT_THREE");
                        data_out_msg.data = update_data(rx_bit, data_out_msg.data, 3);
                        data_out->set(data_out_msg);
                        rxd->read(rx_bit, "GET_BIT_FOUR");
                        data_out_msg.data = update_data(rx_bit, data_out_msg.data, 4);
                        data_out->set(data_out_msg);
                        rxd->read(rx_bit, "GET_BIT_FIVE");
                        data_out_msg.data = update_data(rx_bit, data_out_msg.data, 5);
                        data_out->set(data_out_msg);
                        rxd->read(rx_bit, "GET_BIT_SIX");
                        data_out_msg.data = update_data(rx_bit, data_out_msg.data, 6);
                        data_out->set(data_out_msg);
                        rxd->read(rx_bit, "GET_BIT_SEVEN");
                        data_out_msg.data = update_data(rx_bit, data_out_msg.data, 7);
                        data_out->set(data_out_msg);

                        config_in->get(config_in_msg);
                        if (config_in_msg.parity)
                        {
                            rxd->read(rx_bit, "GET_PARITY_BIT");
                            config_in->get(config_in_msg);
                            parity = rx_bit;
                            if (parity_not_correct(data_out_msg.data, config_in_msg.odd_parity, parity))
                            {
#ifdef SIM
                                debug_print(RX, "ERROR PARITY");
#endif
                                events_out_msg.error_src = ERROR_PARITY_MASK;
                                events_out->master_write(events_out_msg, "ERROR_PARITY");
                                events_out_msg.error_src = 0;
                            }
                        }
                        else
                        {
                            parity = false;
                        }
                        rxd->read(rx_bit, "GET_STOP_BIT");

                        config_in->get(config_in_msg);
                        if (rx_bit != STOP_BIT)
                        {
                            events_out_msg.error_src = ERROR_FRAMING_MASK;
                            if (config_in_msg.two_stop_bits)
                            {
#ifdef SIM
                                debug_print(RX, "ERROR FRAMING");
#endif
                                events_out->master_write(events_out_msg, "ERROR_FRAMING");
                                events_out_msg.error_src = 0;
                            }
                        }
                        first_stop_bit = rx_bit;
                        if (config_in_msg.two_stop_bits)
                        {
                            rxd->read(rx_bit, "GET_STOP_BIT_SECOND");
                            if ((data_out_msg.data == 0) && !parity && !first_stop_bit && !rx_bit)
                            {
#ifdef SIM                      
                                debug_print(RX, "ERROR BREAK");
#endif
                                wait_framing_break = true;
                                events_out_msg.error_src = ERROR_BREAK_MASK;
                            }
                            else if (rx_bit != STOP_BIT)
                            {
#ifdef SIM                        
                                debug_print(RX, "ERROR BREAK"); 
#endif
                                events_out_msg.error_src = ERROR_FRAMING_MASK;
                            }
                        }
                        events_out_msg.ready = true;
                        events_out->master_write(events_out_msg, "EVENT_READY");
                        events_out_msg.ready = false;
                        events_out_msg.error_src = 0;

                        data_out_msg.valid = true;
                        //data_out_msg.data  = data_out_msg.data & DATA_MASK;
                        data_out->set(data_out_msg);
                    }
                }
            }
            else
            {
                data_out_msg.data = 0;
                data_out_msg.valid = false;
                data_out->set(data_out_msg);
                parity = false;
                first_stop_bit = false;
                wait_framing_break = false;
                suspending_count = 0;
            }
        }
    }

//private:
    bool parity_not_correct(unsigned int data, bool odd_parity, bool parity_bit) const
    {
        //std::cout << "Data: " << data << "Parity of data: " << bits_xor(data) << "Received parity bit: " << parity_bit << std::endl;
        if (odd_parity) return ((bits_xor(data)) == 1) == parity_bit;
        else            return ((bits_xor(data)) == 1) != parity_bit;

    }

    unsigned int update_data(bool rx_bit, unsigned int data, unsigned int data_count) const
    {
        if (rx_bit)
        {
            return data | (1 << data_count);
        }
        else
        {
            return data & ~(1 << data_count);
        }
    }

};