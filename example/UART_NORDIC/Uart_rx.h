
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
                //std::cout << "Sending data " << data << ", with data mask " << (data & DATA_MASK) << std::endl;
                data_out->try_write(data & DATA_MASK, success_data_out, "SENDING_DATA");
                if (success_data_out)
                {
                    // The received data was successfully collected
                    if (success_rxd && !rx_bit)
                    {
                        nextsection = RECEIVING_DATA;
                    }
                    else
                    {
                        nextsection = IDLE;
                    }
                }
                else // The received data has not yet been collected by the environment
                {
                    // Start collecting new data if start bit is detected, but report overrun error
                    if (success_rxd && !rx_bit)
                    {
                        nextsection = RECEIVING_DATA;
                        control_resp.error_src = ERROR_OVERRUN_MASK;
                    }
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
                if (success_rxd)
                {
                    //std::cout << "RX: Got data bit " << rx_bit << std::endl;
                    data = update_data(rx_bit, data, data_count);
                    data_count = data_count + 1;
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
                            data_count = data_count + 1;
                        }
                    }
                }
            }
            else if (section == RECEIVING_PARITY)
            {
                insert_state("RECEIVING_PARITY");
                if (success_rxd)
                {
                    //std::cout << "RX: got parity bit " << rx_bit << std::endl;
                    nextsection = RECEIVING_STOP;
                    data = update_data(rx_bit, data, data_count);
                    data_count = data_count + 1;
                   
                    if (parity_not_correct(data, rx_bit))
                    {
                        std::cout << "RX: parity incorrect" << std::endl;
                        control_resp.error_src = ERROR_PARITY_MASK;
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
                    config_in->master_read(config);
                    // check for framing error
                    if (!rx_bit)
                    {
                        control_resp.error_src = ERROR_FRAMING_MASK;
                    }
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
                        if ((data & DATA_ONE_STOP_BIT_MASK) == 0) control_resp.error_src = ERROR_BREAK_MASK;
                    }
                }
            }
            else if (section == RECEIVING_STOP_SECOND)
            {
                insert_state("RECEIVING_STOP_SECOND");
                if (success_rxd)
                {
                    data = update_data(rx_bit, data, data_count);
                    data_count = 0;
                    //std::cout << "RX: Got second stop bit " << rx_bit << std::endl;
                    control_resp.ready = true;
                    if ((data & DATA_TWO_STOP_BITS_MASK) == 0) control_resp.error_src = ERROR_BREAK_MASK;
                    nextsection = SENDING_DATA;
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
            
            if (control_resp.timeout || control_resp.ready || control_resp.error_src != 0)
            {
                //std::cout << "RX: transmitting event" << std::endl;
                control_out->master_write(control_resp, "TRANSMIT_EVENT");
            }

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