
#include "systemc.h"
#include "Interfaces.h"
#include "Uart_types.h"



SC_MODULE(Uart_rx)
{

    blocking_out<unsigned int> data_out;
    blocking_in<bool> rxd; // syncs with the baud rate clock

    master_in<rx_control_out_t> control_in;
    master_in<config_t>         config_in;
    master_out<rx_control_in_t> control_out;

    enum Sections {
        IDLE,
        RECEIVING_DATA,
        RECEIVING_PARITY,
        RECEIVING_STOP,
        RECEIVING_STOP_SECOND
    };
    Sections section, nextsection;

    rx_control_out_t control_req;
    rx_control_in_t  control_resp;
    config_t         config;
    bool             success_rxd;
    bool             success_data_out;
    bool             rx_bit;
    unsigned int     data;
    unsigned int     data_count;
    unsigned int     suspending_count;

    SC_CTOR(Uart_rx):
        data_out("data_out"),
        rxd("rxd"),
        control_in("control_in"),
        control_out("control_out"),
        config_in("config_in"),
        success_rxd(false),
        success_data_out(false),
        data(0),
        data_count(0),
        suspending_count(0),
        rx_bit(false),
        nextsection(IDLE)
    {
        SC_THREAD(fsm);
    }

    void fsm()
    {
        while(true)
        {
            section = nextsection;

            // if (section == SUSPENDED)
            // {
            //     control_in->read(control_req);   
            //     control_resp.ready         = false;
            //     control_resp.timeout       = false;  
            //     control_resp.error_overrun = false;
            //     control_resp.error_parity  = false;
            //     control_resp.error_framing = false;
            //     control_resp.error_break   = false;    
            //     suspending_count = 0;
            //     if (control_req.active)
            //     {
            //         nextsection = IDLE;
            //         std::cout << "RX: Moving to IDLE" << std::endl;
            //     }
            //     control_out->write(control_resp);
            // }
            if (section == IDLE)
            {
                /* HINT: The name of the important state is now related directly to the communication call.
                 * The sections don't affect the name anymore. Either the user provides the according name or the state is only called state_ID.
                 * This on the other hand side allows to write code outside of the section statement, the is executed for all sections.
                 * e.g. the rxd->try_read(rx_bit,success_rxd,"IDLE");
                 *
                 * nb_read / nb_write are renamed to try_read / try_write
                 */

                if (control_resp.ready)
                {
                    data_out->try_write(data,success_data_out,"SENDING_RESPONSE"); // & DATA_MASK
                    control_resp.ready = !success_data_out;
                }
                rxd->try_read(rx_bit,success_rxd,"IDLE");

                if (success_rxd)
                {
                    control_in->master_read(control_req);
                    suspending_count = update_suspending_count(control_req.active, suspending_count);
                    if (timeout_reached(control_req.active, suspending_count))
                    {
                        suspending_count      = 0;
                        control_resp.timeout  = true;
                        control_out->master_write(control_resp);
                        control_resp.timeout = false;
                    }  
                    else if (rx_bit == false && (control_req.active || suspending_count > 0))
                    {
                        if (control_resp.ready)
                        {
                            control_resp.error_overrun = true;
                            control_resp.ready         = false;
                            control_out->master_write(control_resp);
                            control_resp.error_overrun = false;
                        }
                        //std::cout << "RX: Got start bit!" << std::endl;
                        nextsection = RECEIVING_DATA;
                        data_count   = 0;

                    }
                }
            }
            else if (section == RECEIVING_DATA)
            {
                rxd->try_read(rx_bit,success_rxd,"RECEIVING_DATA");
                if (success_rxd)
                {
                    //std::cout << "RX: Got data bit " << rx_bit << std::endl;
                    control_in->master_read(control_req);
                    data = update_data(rx_bit, data, data_count);
                    data_count = data_count + 1;
                    suspending_count = update_suspending_count(control_req.active, suspending_count);
                    if (data_count >= UART_DATA_LENGTH)
                    {
                        config_in->master_read(config);
                        if (config.parity)
                        {
                            nextsection = RECEIVING_PARITY;
                        }
                        else
                        {
                            nextsection = RECEIVING_STOP;
                            data_count = data_count + 1; // ??
                        }
                    }
                }
            }
            else if (section == RECEIVING_PARITY)
            {
                rxd->try_read(rx_bit,success_rxd, "RECEIVING_PARITY");
                if (success_rxd)
                {
                    control_in->master_read(control_req);
                    nextsection = RECEIVING_STOP;
                    data = update_data(rx_bit, data, data_count);
                    data_count = data_count + 1;
                    suspending_count = update_suspending_count(control_req.active, suspending_count);
                   
                    if (parity_not_correct(data, rx_bit))
                    {
                         control_resp.error_parity = true;
                        control_out->master_write(control_resp);
                        control_resp.error_parity = false;
                    }
                }
            }
            else if (section == RECEIVING_STOP)
            {
                rxd->try_read(rx_bit,success_rxd,"RECEIVING_STOP");
                if (success_rxd)
                {
                    control_in->master_read(control_req);
                    data = update_data(rx_bit, data, data_count);
                    data_count = data_count + 1;
                    suspending_count = update_suspending_count(control_req.active, suspending_count);
                    config_in->master_read(config);
                    if (config.two_stop_bits)
                    {
                        nextsection = RECEIVING_STOP_SECOND;
                    }
                    else
                    {
                        data_count = 0;
                        nextsection = IDLE;
                        control_resp.ready = true;
                    }
                    if (!rx_bit || control_resp.ready)
                    {
                        control_resp.error_framing = !rx_bit;
                        control_out->master_write(control_resp);
                        control_resp.error_framing = false;
                    }
                    
                }
            }
            else if (section == RECEIVING_STOP_SECOND)
            {
                 rxd->try_read(rx_bit,success_rxd,"RECEIVING_STOP_SECOND");
                if (success_rxd)
                {
                    control_in->master_read(control_req);
                    data = update_data(rx_bit, data, data_count);
                    data_count = 0;
                    suspending_count = update_suspending_count(control_req.active, suspending_count);
                    //std::cout << "RX: Got second stop bit " << rx_bit << std::endl;
                    control_resp.ready         = true;
                    control_resp.error_break   = data == 0;
                    nextsection = IDLE;
                    control_out->master_write(control_resp);
                    control_resp.error_break = false;
                }
            }

            //wait(SC_ZERO_TIME); //FIXME: this should not be used anymore.
        }
    }

//private:
    bool parity_not_correct(unsigned int data, bool parity_bit) const
    {
        return (bits_xor(data) == 1) != parity_bit;
    }

    unsigned int update_suspending_count(bool active, unsigned int suspending_count) const
    {
        if (active)
        {
            return 0;
        }
        else
        {
            return suspending_count + 1;
        }
    }

    bool timeout_reached(bool active, unsigned int suspending_count) const
    {
        if (!active) return suspending_count >= UART_TIMEOUT;
        return false;
        //return !active && (suspending_count >= UART_TIMEOUT);
    }

    unsigned int update_data(bool rx_bit, unsigned int data, unsigned int data_count) const
    {
        if (rx_bit)
        {
            return data | (1 << data_count);
        }
        return data;
    }

};