
#include "systemc.h"
#include "Interfaces.h"
#include "Uart_types.h"

SC_MODULE(Uart_tx)
{
    blocking_in<unsigned int> data_in;
    blocking_out<bool> txd; // syncs with the baud rate clock

    master_in<tx_control_out_t> control_in;
    master_out<tx_control_in_t> control_out;
    master_in<config_t>         config_in;

    enum Sections { 
        IDLE, 
        TRANSMITTING_START, 
        TRANSMITTING_DATA,
        TRANSMITTING_PARITY,
        TRANSMITTING_STOP,
        TRANSMITTING_STOP_SECOND};
    Sections section, nextsection;

    tx_control_out_t control_req;
    tx_control_in_t  control_resp;
    config_t         config;
    unsigned int     data;
    unsigned int     data_count;
    bool             next_bit;
    bool             success;

    SC_CTOR(Uart_tx):
        data_in("data_in"),
        txd("txd"),
        control_in("control_in"),
        control_out("control_out"),
        config_in("config_in"),
        data(0),
        data_count(0),
        next_bit(false),
        success(false),
        nextsection(IDLE)
    {
        SC_THREAD(fsm);
    }

    void fsm()
    {
        while(true)
        {
            section = nextsection;

            if (section == IDLE)
            {
                control_in->master_read(control_req,"IDLE_GET_CONTROL");
                
                txd->try_write(STOP_BIT,success,"IDLE_WRITE_STOP");
                if (control_req.active && success)// && success_data)
                {
                     data_in->try_read(data,success,"IDLE_GET_DATA");
                    if (success)
                    {
                        //std::cout << "TX: got data!" << std::endl;
                        nextsection = TRANSMITTING_START;
                    }
                }
            }
            else if (section == TRANSMITTING_START)
            {
                txd->write(START_BIT,"TRANSMITTING_START");
                data_count = 0;
                nextsection = TRANSMITTING_DATA;
            }
            else if (section == TRANSMITTING_DATA)
            {
                next_bit = get_next_bit(data, data_count);
                txd->write(next_bit,"TRANSMITTING_DATA");

                data_count = data_count + 1;
                if (data_count >= UART_DATA_LENGTH)
                {
                    data_count = 0;
                    config_in->master_read(config);
                    if (config.parity)
                    {
                        nextsection = TRANSMITTING_PARITY;
                    }
                    else
                    {
                        nextsection = TRANSMITTING_STOP;
                    }
                }
            }
            else if (section == TRANSMITTING_PARITY)
            {
                next_bit = get_parity(data);
                txd->write(next_bit,"TRANSMITTING_PARITY");
                nextsection = TRANSMITTING_STOP;
                config_in->master_read(config);
            }
            else if (section == TRANSMITTING_STOP)
            {
                
                if (config.two_stop_bits)
                {
                    txd->write(STOP_BIT,"TRANSMITTING_STOP_FIRST");
                    nextsection = TRANSMITTING_STOP_SECOND;
                }
                else
                {
                    control_resp.ready = true;
                    nextsection = IDLE;
                    //std::cout << ".... TX: READY EVENT" << std::endl;
                    control_out->master_write(control_resp,"TRANSMITTING_STOP");
                }
            }
            else if (section == TRANSMITTING_STOP_SECOND)
            {
                //TODO: this should be send along t with the first stop bit ... is that correct? I'd expect another txd_write
                control_resp.ready = true;  
                nextsection = IDLE;
                //std::cout << ".... TX: READY EVENT" << std::endl;
                control_out->master_write(control_resp,"TRANSMITTING_STOP_SECOND");
            }
            //wait(SC_ZERO_TIME); //FIXME: don't use anymore
        }
    }

private:
    bool get_parity(unsigned int data) const
    {
        return bits_xor(data) == 1;
    }

    bool get_next_bit(unsigned int data, unsigned int data_count) const
    {
        return  data & (1 << data_count);
    }

};