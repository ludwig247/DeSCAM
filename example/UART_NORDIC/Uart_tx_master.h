
#include "systemc.h"
#include "Interfaces.h"
#include "Uart_types.h"

SC_MODULE(Uart_tx)
{
    blocking_in<unsigned int> data_in;
    blocking_out<bool> txd; // syncs with the baud rate clock

    //shared_in<tx_control_out_t> control_in;
    //shared_out<tx_control_in_t> control_out;
    master_in<tx_control_out_t> control_in;
    master_out<tx_control_in_t> control_out;
    shared_in<config_t>         config_in;

    enum Sections {//DISABLED, 
        SUSPENDED, 
        IDLE, 
        TRANSMITTING_START, 
        TRANSMITTING_DATA,
        TRANSMITTING_PARITY,
        TRANSMITTING_STOP_WAIT,
        TRANSMITTING_STOP,
        TRANSMITTING_STOP_SECOND_WAIT,
        TRANSMITTING_STOP_SECOND};
    Sections section, nextsection;

    tx_control_out_t control;
    tx_control_in_t  control_resp;
    config_t         config;
    unsigned int data;
    unsigned int data_count;
    bool         go_to_suspended;
    bool         next_bit;
    bool success;

    SC_CTOR(Uart_tx):
        data_in("data_in"),
        txd("txd"),
        control_in("control_in"),
        control_out("control_out"),
        data(0),
        data_count(0),
        next_bit(false),
        success(false),
        nextsection(SUSPENDED)
    {
        SC_THREAD(fsm);
    }

    void fsm()
    {
        while(true)
        {
            section = nextsection;
            
            if (section == SUSPENDED)
            {
                control_in->read(control);
                control_resp.ready = false;
                if (control.active)
                {
                    std::cout << "TX: moving to IDLE" << std::endl;
                    nextsection = IDLE;
                }
                control_out->write(control_resp);
            }
            else if (section == IDLE)
            {
                control_in->read(control);
                if (!control.active)
                {
                    nextsection = SUSPENDED;
                }
                else
                {
                    std::cout << "TX: idle, waiting for data" << std::endl;
                    success = data_in->nb_read(data);
                    std::cout << "TX: got data!" << std::endl;
                    if (success)
                    {
                        control_resp.ready = false;
                        nextsection = TRANSMITTING_START;
                        control_out->write(control_resp);
                    }
                }
            }
            else if (section == TRANSMITTING_START)
            {
                //control_in->read(control);
                std::cout << "TX: writing start bit" << std::endl;
                success = txd->nb_write(START_BIT);
                if (success)
                {
                    data_count = 0;
                    nextsection = TRANSMITTING_DATA;
                }
                //control_out->write(control_resp);
            }
            else if (section == TRANSMITTING_DATA)
            {
                //control_in->read(control);
                if (data_count >= UART_DATA_LENGTH)
                {
                    config_in->get(config);
                    if (config.parity)
                    {
                        nextsection = TRANSMITTING_PARITY;
                    }
                    else
                    {
                        nextsection = TRANSMITTING_STOP;
                    }
                    
                }
                else
                {
                    //std::cout << "TX: writing bit nr " << data_count << std::endl;
                    next_bit = get_next_bit(data, data_count);
                    success = txd->nb_write(next_bit);
                    if (success)
                    {
                        data_count = data_count + 1;
                    }
                }
                //control_out->write(control_resp);
            }
            else if (section == TRANSMITTING_PARITY)
            {
                std::cout << "TX: transmitting parity" << std::endl;
                next_bit = get_parity(data);
                success = txd->nb_write(next_bit);
                if (success)
                {
                    nextsection = TRANSMITTING_STOP_WAIT;
                }
            }
            else if (section == TRANSMITTING_STOP_WAIT)
            {
                std::cout << "TX: transmitting first stop bit" << std::endl;
                success = txd->nb_write(STOP_BIT);
                if (success)
                {
                    nextsection = TRANSMITTING_STOP;
                }
            }
            else if (section == TRANSMITTING_STOP)
            {
                config_in->get(config);
                if (config.two_stop_bits)
                {
                    nextsection = TRANSMITTING_STOP_SECOND_WAIT;
                }
                else
                {
                    control_in->read(control);
                    control_resp.ready = true;
                    if (!control.active)
                    {
                        nextsection = SUSPENDED;
                    }
                    else
                    {
                        nextsection = IDLE;
                    }
                    control_out->write(control_resp);
                }
                
            }
            else if (section == TRANSMITTING_STOP_SECOND_WAIT)
            {
                std::cout << "TX: transmitting second stop bit" << std::endl;
                success = txd->nb_write(STOP_BIT);
                if (success)
                {
                    nextsection = TRANSMITTING_STOP_SECOND;
                }
            }
            else if (section == TRANSMITTING_STOP_SECOND)
            {
                control_in->read(control);
                control_resp.ready = true;
                if (!control.active)
                {
                    nextsection = SUSPENDED;
                }
                else
                {
                    nextsection = IDLE;
                }
                control_out->write(control_resp);
            }
            

            wait(SC_ZERO_TIME);
        }
    }

private:
    bool get_parity(unsigned int data) const
    {
        return bits_xor(data) == 1;
    }

    bool get_next_bit(unsigned int data, unsigned int data_count) const
    {
        //bool return_bit = data & (1 << data_count);
        //data_count++;
        return  data & (1 << data_count);
    }

};