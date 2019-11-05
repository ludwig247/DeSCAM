#include "systemc.h"
#include "Interfaces.h"
#include "Uart_types.h"

SC_MODULE(Uart_control)
{
    slave_in<bus_req_t>          bus_in;
    slave_out<bus_resp_t>        bus_out;
    shared_in<tasks_t>           tasks_in;
    shared_out<events_t>         events_out;

    shared_in<bool>              cts_in;
    shared_out<bool>             rts_out;

    shared_out<tx_control_out_t> tx_control_out;
    shared_in<tx_control_in_t>   tx_control_in;
    shared_out<rx_control_out_t> rx_control_out;
    shared_in<rx_control_in_t>   rx_control_in;

    shared_out<config_t>         rx_config_out; // Have only one output?
    shared_out<config_t>         tx_config_out;

    enum Sections {IDLE,
        TRANS_WRITE,
        TRANS_READ,
        TASKS_EVENTS
    };
    Sections section, nextsection;

    enum task_types {START_RX, STOP_RX, START_TX, STOP_TX, SUSPEND};

    bus_req_t        bus_request;
    bus_resp_t       bus_response;
    bool             ongoing_bus_transaction;
    tx_control_out_t tx_control_req;
    tx_control_in_t  tx_control_resp;
    rx_control_out_t rx_control_req;
    rx_control_in_t  rx_control_resp;
    tasks_t          tasks;
    events_t         events;
    bool             cts;
    bool             rts;
    config_t         config_msg;

    // Registers
    unsigned int events_cts;
    unsigned int events_ncts;
    unsigned int events_rxd_ready;
    unsigned int events_txd_ready;
    unsigned int events_error;
    unsigned int events_rx_timeout;
    unsigned int error_src;
    unsigned int enable;
    unsigned int config;

    SC_CTOR(Uart_control):
        events_cts(0),
        events_ncts(0),
        events_rxd_ready(0),
        events_txd_ready(0),
        events_error(0),
        events_rx_timeout(0),
        error_src(0),
        enable(0),
        config(0),
        rts(RTS_DEACTIVATED),
        ongoing_bus_transaction(false),
        nextsection(IDLE),
        bus_in("bus_in"),
        bus_out("bus_out"),
        tx_control_in("tx_control_in"),
        tx_control_out("tx_control_out"),
        rx_control_in("rx_control_in"),
        rx_control_out("rx_control_out")
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
                tasks_in->get(tasks);
                tx_control_in->get(tx_control_resp);
                rx_control_in->get(rx_control_resp);
                cts_in->get(cts);
                ongoing_bus_transaction = bus_in->nb_read(bus_request);

                if (ongoing_bus_transaction && bus_request.trans_type == WRITE && 
                    bus_request.addr != ADDR_TASKS_SUSPEND && 
                    bus_request.addr != ADDR_TASKS_STOP_TX &&
                    bus_request.addr != ADDR_TASKS_STOP_RX &&
                    bus_request.addr != ADDR_TASKS_START_RX &&
                    bus_request.addr != ADDR_TASKS_START_TX)// && no_task_trans())
                {
                    nextsection = TRANS_WRITE;
                }
                else if (ongoing_bus_transaction && bus_request.trans_type == READ && 
                    bus_request.addr != ADDR_TASKS_SUSPEND && 
                    bus_request.addr != ADDR_TASKS_STOP_TX &&
                    bus_request.addr != ADDR_TASKS_STOP_RX &&
                    bus_request.addr != ADDR_TASKS_START_RX &&
                    bus_request.addr != ADDR_TASKS_START_TX)
                {
                        nextsection = TRANS_READ;
                }
                else if (is_one(enable))
                {
                    nextsection = TASKS_EVENTS;
                }
            }   

            else if (section == TRANS_WRITE)
            {
                
                if (bus_request.addr == ADDR_EVENTS_CTS)
                {
                    events_cts = bus_request.data & 1;
                }
                else if (bus_request.addr == ADDR_EVENTS_NCTS)
                {
                    events_ncts = bus_request.data & 1;
                }
                else if (bus_request.addr == ADDR_EVENTS_RXD_READY)
                {
                    events_rxd_ready = bus_request.data & 1;
                }
                else if (bus_request.addr == ADDR_EVENTS_TXD_READY)
                {
                    events_txd_ready = bus_request.data & 1;
                }
                else if (bus_request.addr == ADDR_EVENTS_ERROR)
                {
                    events_error = bus_request.data & 1;
                }
                else if (bus_request.addr == ADDR_EVENTS_RX_TIMEOUT)
                {
                    events_rx_timeout = bus_request.data & 1;
                }
                else if (bus_request.addr == ADDR_ERROR_SRC)
                {
                    /*
                    if (bus_request.data & ERROR_OVERRUN_MASK)
                    {
                        error_src = error_src & ERROR_OVERRUN_MASK_INV;
                    }
                    if (bus_request.data & ERROR_PARITY_MASK)
                    {
                        error_src = error_src & ERROR_PARITY_MASK_INV;
                    }
                    if (bus_request.data & ERROR_FRAMING_MASK)
                    {
                        error_src = error_src & ERROR_FRAMING_MASK_INV;
                    }
                    if (bus_request.data & ERROR_BREAK_MASK)
                    {
                        error_src = error_src & ERROR_BREAK_MASK_INV;
                    }*/
                    //error_src = error_src & ~bus_request.data & ERROR_SRC_MASK;
                }

                else if (bus_request.addr == ADDR_ENABLE)
                {
                    enable = bus_request.data & 1;
                }

                else if (bus_request.addr == ADDR_CONFIG)
                {
                    config = bus_request.data & CONFIG_BIT_MASK;
                    config_msg.parity = parity_enabled();
                    config_msg.two_stop_bits = two_stop_bits_enabled();
                    tx_config_out->set(config_msg);
                    rx_config_out->set(config_msg);
                }
                ongoing_bus_transaction = false;
                if (is_one(enable))
                {
                    nextsection = TASKS_EVENTS;
                }
                else
                {
                    nextsection = IDLE;
                }
            }

            else if (section == TASKS_EVENTS)
            {
                
                nextsection = IDLE;
                //tx_control_req.start         = is_task(tasks.start_tx, ADDR_TASKS_START_TX) 
                //                               || (hfw_enabled() && cts == CTS_ACTIVATED);
                //tx_control_req.stop          = is_task(tasks.stop_tx,  ADDR_TASKS_STOP_TX);
                //tx_control_req.suspend       = is_task(tasks.suspend,  ADDR_TASKS_SUSPEND) 
                //                               || (hfw_enabled() && cts == CTS_DEACTIVATED);
                //tx_control_req.parity        = parity_enabled();
                //tx_control_req.two_stop_bits = two_stop_bits_enabled();
 
                //rx_control_req.start         = is_task(tasks.start_rx, ADDR_TASKS_START_RX);
                //rx_control_req.stop          = is_task(tasks.stop_rx,  ADDR_TASKS_STOP_RX);
                //rx_control_req.suspend       = is_task(tasks.suspend,  ADDR_TASKS_SUSPEND);
                //rx_control_req.parity        = parity_enabled();
                //rx_control_req.two_stop_bits = two_stop_bits_enabled();


                tx_control_req.active = update_active(tx_control_req.active, 
                                          task_triggered(START_TX) || (hfw_enabled() && cts == CTS_ACTIVATED), 
                                          task_triggered(STOP_TX) || task_triggered(SUSPEND) || (hfw_enabled() && cts == CTS_DEACTIVATED));
                rx_control_req.active = update_active(rx_control_req.active, 
                                          task_triggered(START_RX), 
                                          task_triggered(STOP_RX) || task_triggered(SUSPEND));
                tx_control_out->set(tx_control_req);
                rx_control_out->set(rx_control_req);

                if (hfw_enabled())
                {
                    if (rx_control_req.active)
                    {
                        rts = RTS_ACTIVATED;
                    }
                    else 
                    {
                        rts = RTS_DEACTIVATED;
                    }
                    rts_out->set(rts);
                }

                events.cts        = false;
                events.ncts       = false;
                events.txd_ready  = tx_control_resp.ready && is_one(events_txd_ready);
                events.rxd_ready  = rx_control_resp.ready && is_one(events_rxd_ready);
                events.rx_timeout = rx_control_resp.timeout && is_one(events_rx_timeout);
                events.error      = (rx_control_resp.error_overrun 
                                    || rx_control_resp.error_parity
                                    || rx_control_resp.error_framing
                                    || rx_control_resp.error_break) && is_one(events_error);
                
                events_out->set(events);
            }

            else if (section == TRANS_READ)
            {
                if (is_one(enable))
                {
                    nextsection = TASKS_EVENTS;
                }
                else
                {
                    nextsection = IDLE;
                }
                
                if (bus_request.addr == ADDR_EVENTS_CTS)
                {
                    bus_response.data = events_cts;
                }
                else if (bus_request.addr == ADDR_EVENTS_NCTS)
                {
                    bus_response.data = events_ncts;
                }
                else if (bus_request.addr == ADDR_EVENTS_RXD_READY)
                {
                    bus_response.data = events_rxd_ready;
                }
                else if (bus_request.addr == ADDR_EVENTS_TXD_READY)
                {
                    bus_response.data = events_txd_ready;
                }
                else if (bus_request.addr == ADDR_EVENTS_ERROR)
                {
                    bus_response.data = events_error;
                }
                else if (bus_request.addr == ADDR_EVENTS_RX_TIMEOUT)
                {
                    bus_response.data = events_rx_timeout;
                }
                else if (bus_request.addr == ADDR_ERROR_SRC)
                {
                    bus_response.data = error_src;
                }
                else if (bus_request.addr == ADDR_ENABLE)
                {
                    bus_response.data = enable;
                }
                else if (bus_request.addr == ADDR_CONFIG)
                {
                    bus_response.data = config;
                }
                bus_out->nb_write(bus_response); //FIXME: do you accept losing this message?
                ongoing_bus_transaction = false;
            }
            
            wait(SC_ZERO_TIME);
        }
    }
private:
    bool parity_enabled() const
    {
        return ((config & CONFIG_PARITY_MASK) >> CONFIG_PARITY_BIT_OFFSET) == 0x7;
    }
    bool two_stop_bits_enabled() const
    {
        return (config & CONFIG_STOP_MASK) >> CONFIG_STOP_BIT_OFFSET;
    }
    bool hfw_enabled() const
    {
        return (config & CONFIG_HFW_MASK) >> CONFIG_HFW_BIT_OFFSET;
    }

    bool is_one(unsigned int reg_value) const
    {
        return reg_value == 1;
    }

    bool is_task(bool task, unsigned int addr) const
    {
        return task || 
            (ongoing_bus_transaction && 
            bus_request.trans_type == WRITE && 
            bus_request.addr == addr && 
            //bus_request.data & 1);
            is_one(bus_request.data & 1));
    }
    bool task_triggered(task_types task_type)
    {
        if (task_type == START_RX)
        {
            return is_task(tasks.start_rx, ADDR_TASKS_START_RX);
        }
        if (task_type == STOP_RX)
        {
            return is_task(tasks.stop_rx, ADDR_TASKS_STOP_RX);
        }
        if (task_type == START_TX)
        {
            return is_task(tasks.start_tx, ADDR_TASKS_START_TX);
        }
        if (task_type == STOP_TX)
        {
            return is_task(tasks.stop_tx, ADDR_TASKS_STOP_TX);
        }
        if (task_type == SUSPEND)
        {
            return is_task(tasks.suspend, ADDR_TASKS_SUSPEND);
        }
        return 0;
    }

    bool update_active(bool prev, bool start, bool stop) const
    {
        if (prev) // we are arleady in run
        {
            return !(stop) || start;
        }
        else
        {
            return start;
        }
    }
    
    bool no_task_trans() const
    {
        return bus_request.addr != ADDR_TASKS_SUSPEND && 
               bus_request.addr != ADDR_TASKS_START_TX &&
               bus_request.addr != ADDR_TASKS_STOP_RX &&
               bus_request.addr != ADDR_TASKS_STOP_TX &&
               bus_request.addr != ADDR_TASKS_START_RX;
    }
};