
#include "systemc.h"
#include "Interfaces.h"
#include "Uart_types.h"



SC_MODULE(Uart_rx)
{

    blocking_out<unsigned int> data_out;
    blocking_in<bool> rxd; // syncs with the baud rate clock

    //master_in<rx_control_out_t> control_in;
    //slave_out<rx_control_in_t> control_out;
    shared_in<rx_control_out_t> control_in;
    shared_in<config_t>         config_in;
    shared_out<rx_control_in_t> control_out;

    enum Sections {//DISABLED,
        SUSPENDED,
        IDLE,
        RECEIVING_DATA,
        RECEIVING_PARITY,
        RECEIVING_STOP,
        RECEIVING_STOP_SECOND};
    Sections section, nextsection;

    rx_control_out_t control;
    rx_control_in_t  control_resp;
    config_t         config;
    bool             rx_bit;
    unsigned int     data;
    unsigned int     data_count;
    unsigned int     go_to_suspended_count;

    SC_CTOR(Uart_rx):
        data_out("data_out"),
        rxd("rxd"),
        control_in("control_in"),
        control_out("control_out"),
        data(0),
        data_count(0),
        go_to_suspended_count(0),
        rx_bit(false),
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

                go_to_suspended_count = 0;
                if (control.active)
                {
                    nextsection = IDLE;
                    std::cout << "RX: Moving to IDLE" << std::endl;
                }

            }
            else if (section == IDLE)
            {
                control_in->get(control);
                rxd->read(rx_bit);
                if (!control.active)
                {
                    go_to_suspended_count = go_to_suspended_count + 1;
                }
                
                if (!control.active && go_to_suspended_count >= UART_TIMEOUT)
                {
                    go_to_suspended_count = 0;
                    control_resp.timeout  = true;
                    nextsection           = SUSPENDED;
                }
                    
                else if (rx_bit == START_BIT)
                {
                    std::cout << "RX: Got start bit!" << std::endl;
                    nextsection = RECEIVING_DATA;
                    data_count   = 0;
                    
                   
                }
                control_out->set(control_resp);
            }
            else if (section == RECEIVING_DATA)
            {
                rxd->read(rx_bit);
                std::cout << "RX: Got data bit " << rx_bit << std::endl;
                if (rx_bit)
                {
                    data = data | (1 << data_count);
                }
                data_count = data_count + 1;
                if (!control.active)
                {
                    go_to_suspended_count = go_to_suspended_count + 1;
                }
                
                if (data_count >= UART_DATA_LENGTH)
                {
                    config_in->get(config);
                    if (config.parity)
                    {
                        nextsection = RECEIVING_PARITY;
                    }
                    else
                    {
                        nextsection = RECEIVING_STOP;
                        data_count = data_count + 1;
                    }
                }
                control_out->set(control_resp);
            }
            else if (section == RECEIVING_PARITY)
            {
                control_in->get(control);
                rxd->read(rx_bit);
                if (rx_bit)
                {
                    data = data | (1 << data_count);
                }
                data_count = data_count + 1;
                if (!control.active)
                {
                    go_to_suspended_count = go_to_suspended_count + 1;
                }
                std::cout << "RX: Got parity bit " << rx_bit << std::endl;
                control_resp.error_parity = parity() != rx_bit;
                nextsection = RECEIVING_STOP;
                control_out->set(control_resp);
            }
            else if (section == RECEIVING_STOP)
            {
                
                rxd->read(rx_bit);
                if (rx_bit)
                {
                    data = data | (1 << data_count);
                }
                data_count = data_count + 1;
                if (!control.active)
                {
                    go_to_suspended_count = go_to_suspended_count + 1;
                }
                std::cout << "RX: Got stop bit " << rx_bit << std::endl;
                control_resp.error_framing = !rx_bit;
                config_in->get(config);
                if (config.two_stop_bits)
                {
                    std::cout << "RX: moving to second stop bit" << std::endl;
                    nextsection = RECEIVING_STOP_SECOND;
                }
                else
                {
                    std::cout << "RX: writing data" << std::endl;
                    data_out->write(data & DATA_MASK);
                    std::cout << "RX: Moving back to IDLE" << std::endl;
                    nextsection = IDLE;
                }
                control_out->set(control_resp);
            }
            else if (section == RECEIVING_STOP_SECOND)
            {
                control_in->get(control);
                rxd->read(rx_bit);
                if (rx_bit)
                {
                    data = data | (1 << data_count);
                }
                data_count = 0;
                if (!control.active)
                {
                    go_to_suspended_count = go_to_suspended_count + 1;
                }
                std::cout << "RX: Got second stop bit " << rx_bit << std::endl;
                control_resp.error_break = data == 0;
                data_out->write(data & DATA_MASK);
                nextsection = IDLE;
                control_out->set(control_resp);
            }
            //control_out->set(control_resp);

            wait(SC_ZERO_TIME);
        }
    }

//private:
    bool parity() const
    {
        return bits_xor(data) == 1;
    }
/*
    void process_rxd()
    {
        if (rx_bit)
        {
            data |= (1 << data_count);
        }
        data_count++;
        if (go_to_suspended)
        {
            go_to_suspended_count++;
            std::cout << "RX: Suspended count is " << go_to_suspended_count << std::endl;
        }
    }*/

};