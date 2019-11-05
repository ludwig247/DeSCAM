
#include "systemc.h"
#include "Interfaces.h"
#include "Uart_types.h"

SC_MODULE(Uart_tx)
{
    blocking_in<unsigned int> data_in;
    blocking_out<bool> txd; // syncs with the baud rate clock

    shared_in<tx_control_out_t> control_in;
    shared_in<config_t>         config_in;
    shared_out<tx_control_in_t> control_out;

    enum Sections {
        SUSPENDED, 
        IDLE, 
        TRANSMITTING_START, 
        TRANSMITTING_DATA,
        TRANSMITTING_PARITY,
        TRANSMITTING_STOP,
        TRANSMITTING_STOP_SECOND};
    Sections section, nextsection;

    tx_control_out_t control;
    tx_control_in_t  control_resp;
    config_t         config;
    unsigned int data;
    unsigned int data_count;
    bool         next_bit;

    SC_CTOR(Uart_tx):
        data_in("data_in"),
        txd("txd"),
        control_in("control_in"),
        control_out("control_out"),
        data(0),
        data_count(0),
        next_bit(false),
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
                control_in->get(control);
                if (control.active)
                {
                    std::cout << "TX: moving to IDLE" << std::endl;
                    nextsection = IDLE;
                }
            }
            else if (section == IDLE)
            {
                control_in->get(control);
                if (!control.active)
                {
                    nextsection = SUSPENDED;
                }
                else
                {
                    std::cout << "TX: idle, waiting for data" << std::endl;
                    data_in->read(data);
                    std::cout << "TX: got data!" << std::endl;
                    control_resp.ready = false;
                    control_out->set(control_resp);
                    nextsection = TRANSMITTING_START;
                }
            }
            else if (section == TRANSMITTING_START)
            {
                std::cout << "TX: writing start bit" << std::endl;
                txd->write(START_BIT);
                data_count = 0;
                nextsection = TRANSMITTING_DATA;
            }
            else if (section == TRANSMITTING_DATA)
            {
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
                    data_count++;
                    txd->write(next_bit);
                }
            }
            else if (section == TRANSMITTING_PARITY)
            {
                std::cout << "TX: transmitting parity" << std::endl;
                next_bit = get_parity(data);
                txd->write(next_bit);
                nextsection = TRANSMITTING_STOP;
            }
            else if (section == TRANSMITTING_STOP)
            {
                std::cout << "TX: transmitting first stop bit" << std::endl;
                txd->write(STOP_BIT);
                config_in->get(config);
                if (config.two_stop_bits)
                {
                    nextsection = TRANSMITTING_STOP_SECOND;
                }
                else
                {
                    control_resp.ready = true;
                    control_out->set(control_resp);
                    if (!control.active)
                    {
                        nextsection = SUSPENDED;
                    }
                    else
                    {
                        nextsection = IDLE;
                    }
                }
            }
            else if (section == TRANSMITTING_STOP_SECOND)
            {
                std::cout << "TX: transmitting second stop bit" << std::endl;
                txd->write(STOP_BIT);
                control_in->get(control);
                control_resp.ready = true;
                control_out->set(control_resp);
                if (!control.active)
                    {
                        nextsection = SUSPENDED;
                    }
                    else
                    {
                        nextsection = IDLE;
                    }
            }


            wait(SC_ZERO_TIME);
        }
    }

private:
    bool get_parity(unsigned int data) const
    {
        //unsigned int temp_data = data;
        bool result = 0;
        //for (int i = 0; i < UART_DATA_LENGTH; i++)
        //{
        //    result ^= data & 1;
        //    data >>= 1;
        //}
        return result;
    }

    bool get_next_bit(unsigned int data, unsigned int data_count) const
    {
        //bool return_bit = data & (1 << data_count);
        //data_count++;
        return  data & (1 << data_count);
    }

};