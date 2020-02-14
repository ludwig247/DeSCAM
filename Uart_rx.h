
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
        SENDING_DATA,
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
    bool             timeout;

    SC_CTOR(Uart_rx):
        data_out("data_out"),
        rxd("rxd"),
        control_in("control_in"),
        control_out("control_out"),
        config_in("config_in"),
        success_rxd(false),
        success_data_out(false),
        timeout(false),
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
            control_in->master_read(control_req);
            rxd->try_read(rx_bit, success_rxd); // Always check for new incoming rxd bits
            control_resp.timeout       = false;
            control_resp.ready         = false;
            control_resp.error_src     = 0;

            if (section == SENDING_DATA)
            {
                //insert_state("SEND_DATA");
                //std::cout << "Sending data " << data << ", with data mask " << (data & DATA_MASK) << std::endl;
                data_out->try_write(data & DATA_MASK, success_data_out, "SEND_DATA");
                //rxd->try_read(rx_bit, success_rxd); // Always check for new incoming rxd bits
                if (success_rxd && !rx_bit  && !timeout)
                {
                    nextsection = RECEIVING_DATA;
                    data_count = 0;
                    if (!success_data_out)
                    {
                        //control_resp.error_overrun = true;
                        control_resp.error_src = ERROR_OVERRUN_MASK;
                        control_out->master_write(control_resp);
                    }
                }
                else if (success_data_out || timeout)
                {
                    nextsection = IDLE;
                }
            }
            
            else if (section == IDLE)
            {
                insert_state("IDLE");
                /* HINT: The name of the important state is now related directly to the communication call.
                 * The sections don't affect the name anymore. Either the user provides the according name or the state is only called state_ID.
                 * This on the other hand side allows to write code outside of the section statement, the is executed for all sections.
                 * e.g. the rxd->try_read(rx_bit,success_rxd,"IDLE");
                 *
                 * nb_read / nb_write are renamed to try_read / try_write
                 */

                if (success_rxd)
                {
                    if (!rx_bit && !timeout)
                    {
                        //std::cout << "RX: Got start bit!" << std::endl;
                        nextsection = RECEIVING_DATA;
                        data_count   = 0;
                    }
                }
            }
            else if (section == RECEIVING_DATA)
            {
                insert_state("RECEIVING_DATA");
                //rxd->try_read(rx_bit,success_rxd,"RECEIVING_DATA");
                if (success_rxd)
                {
                    //std::cout << "RX: Got data bit " << rx_bit << std::endl;
                    data = update_data(rx_bit, data, data_count);
                    //std::cout << "New data is " << data << std::endl;
                    data_count = data_count + 1;
                    //suspending_count = update_suspending_count(control_req.active, suspending_count);
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
                            data = update_data(false, data, data_count); // insert 0 if no parity bit
                            data_count = data_count + 1; // ??
                        }
                    }
                }
            }
            else if (section == RECEIVING_PARITY)
            {
                insert_state("RECEIVING_PARITY");
                //rxd->try_read(rx_bit,success_rxd, "RECEIVING_PARITY");
                if (success_rxd)
                {
                    //std::cout << "RX: got parity bit " << rx_bit << std::endl;
                    nextsection = RECEIVING_STOP;
                    data = update_data(rx_bit, data, data_count);
                    data_count = data_count + 1;
                    //suspending_count = update_suspending_count(control_req.active, suspending_count);
                   
                    if (parity_not_correct(data, rx_bit))
                    {
                        std::cout << "RX: parity incorrect" << std::endl;
                        //control_resp.error_parity = true;
                        //control_resp.error_src = ERROR_PARITY_MASK;
                        control_out->master_write(control_resp);
                    }
                }
            }
            else if (section == RECEIVING_STOP)
            {
                insert_state("RECEIVING_STOP");
                //rxd->try_read(rx_bit,success_rxd,"RECEIVING_STOP");
                if (success_rxd)
                {
                    //std::cout << "RX: got first stop bit" << std::endl;
                    data = update_data(rx_bit, data, data_count);
                    
                    //suspending_count = update_suspending_count(control_req.active, suspending_count);
                    config_in->master_read(config);
                    if (config.two_stop_bits)
                    {
                        nextsection = RECEIVING_STOP_SECOND;
                        data_count = data_count + 1;
                    }
                    else
                    {
                        data_count = 0;
                        nextsection = SENDING_DATA;
                        control_resp.ready = true;
                        //if (data == 0) control_resp.error_src = ERROR_BREAK_MASK; // TODO: data mask
                        control_out->master_write(control_resp);
                    }
                    if (!rx_bit || control_resp.ready)
                    {
                        //control_resp.error_framing = !rx_bit;
                        //control_resp.error_src = ERROR_FRAMING_MASK;
                        control_out->master_write(control_resp);
                        //control_out->master_write(control_resp);
                        // control_resp.error_framing = false;
                    }
                    
                }
            }
            else if (section == RECEIVING_STOP_SECOND)
            {
                insert_state("RECEIVING_STOP_SECOND");
                //rxd->try_read(rx_bit,success_rxd,"RECEIVING_STOP_SECOND");
                if (success_rxd)
                {
                    data = update_data(rx_bit, data, data_count);
                    data_count = 0;
                    //suspending_count = update_suspending_count(control_req.active, suspending_count);
                    //std::cout << "RX: Got second stop bit " << rx_bit << std::endl;
                    control_resp.ready         = true;
                    //control_resp.error_break   = data == 0; // TODO only check actually used bits
                    //if (data == 0) control_resp.error_src = ERROR_BREAK_MASK; // TODO: data mask
                    nextsection = SENDING_DATA;
                    control_out->master_write(control_resp);
                }
            }

            
            suspending_count = update_suspending_count(control_req.active, suspending_count);
            if (timeout_reached(control_req.active, suspending_count))
            {
                suspending_count      = 0;
                control_resp.timeout  = true;
                timeout               = true;
                nextsection = IDLE;
            }
            else if (control_req.active)
            {
                suspending_count = 0;
                timeout = false;
            }
            
            // if (control_resp.error_overrun || 
            //     control_resp.error_parity || 
            //     control_resp.error_framing || 
            //     control_resp.error_break || 
            //     control_resp.timeout || 
            //     control_resp.ready)
            // {
            //     std::cout << "RX: transmitting event" << std::endl;
            //     control_out->master_write(control_resp, "TRANSMIT_EVENT");
            // }
            // control_resp.error_overrun = false;
            // control_resp.error_parity  = false;
            // control_resp.error_framing = false;
            // control_resp.error_break   = false;

        }
    }

//private:
    bool parity_not_correct(unsigned int data, bool parity_bit) const
    {
        std::cout << "Data: " << data << "Parity of data: " << bits_xor(data) << "Received parity bit: " << parity_bit << std::endl;
        return ((bits_xor(data)) == 1) != parity_bit;
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
        else
        {
            return data & ~(1 << data_count);
        }
    }

};