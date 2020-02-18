#include "systemc.h"
#include "Interfaces.h"
#include "Uart_types.h"

#define ERROR_BIT(x)   (x & 0xF)
#define ENABLE_BIT(x)  (x & 1)
#define CONFIG_BIT(x)  (x & 0x1F)
#define PARITY_BIT(x)  (x & 0xE)
#define STOP_BIT(x)    (x & 0x1)
#define HWFC_BIT(x)    (x & 0x10)

SC_MODULE(Uart_control) {
    slave_in<bus_req_t> bus_in;
    slave_out<bus_resp_t> bus_out;
    slave_in<tasks_t> tasks_in;
    master_out<events_t> events_out;

    //slave_in<bool> cts_in;
    //master_out<bool> rts_out;
    slave_out<rx_control_out_t> hwfc_control_out;

    slave_out<tx_control_out_t> tx_control_out;
    slave_in<tx_control_in_t> tx_control_in;
    slave_out<rx_control_out_t> rx_control_out;
    slave_in<rx_control_in_t> rx_control_in;

    slave_out<config_t> rx_config_out;
    slave_out<config_t> tx_config_out;

    bus_req_t bus_request;
    bus_resp_t bus_response;

    tx_control_out_t tx_control_req;
    tx_control_in_t tx_control_resp;
    rx_control_out_t rx_control_req;
    rx_control_in_t rx_control_resp;
    rx_control_out_t hwfc_control_req;
    tasks_t tasks;
    tasks_t tasks_internal;
    events_t events;
    bool cts;
    bool cts_in_valid;
    //bool rts;
    bool bus_in_valid;
    bool tasks_in_valid;
    bool tx_control_in_valid;
    bool rx_control_in_valid;
    bool is_bus_write;
    bool is_bus_read;

    // Registers
    unsigned int error_src;
    unsigned int enable;
    unsigned int config;
    //bool error_overrun;
    //bool error_parity;
    //bool error_framing;
    //bool error_break;
    //bool enable;
    //bool hwfc;
    config_t config_msg;


    // Registers
    //registers_t registers;

    SC_CTOR(Uart_control) :
            //rts(RTS_DEACTIVATED),
            cts(CTS_DEACTIVATED),
            cts_in_valid(false),
            bus_in_valid(false),
            tx_control_in_valid(false),
            rx_control_in_valid(false),
            tasks_in_valid(false),
            error_src(0),
            enable(0),
            config(0),
            bus_in("bus_in"),
            bus_out("bus_out"),
            tx_control_in("tx_control_in"),
            tx_control_out("tx_control_out"),
            rx_control_in("rx_control_in"),
            rx_control_out("rx_control_out"),
            hwfc_control_out("hwfc_control_out"),
            tasks_in("tasks"),
            events_out("events"),
            tx_config_out("tx_config_out"),
            rx_config_out("rx_config_out"),
            is_bus_write(false),
            is_bus_read(false)//,
            //cts_in("cts_in")//,
            //rts_out("rts_out") 
            {
        //registers.error_src = 0;
        //registers.enable = 0;
        //registers.config = 0;
        SC_THREAD(fsm);
    }

    void fsm() {
        while (true) {
            insert_state("conceptual_state"); //TODO: Provide own name here


            /*
             * Changes:
             * 1) renaming of functions
             * 2) success is now returned as a pass by value (e.g. line 75)
             * 3) as you may see in line 69 it is now possible to insert important states that are not related to a communication.
             *    In this case this state is required, because slave communications don't block anymore. a sequence:
             *          slave->slave_read()
             *          slave->slave_read()
             *          slave->slave_read()
             *          slave->slave_write()
             *          slave->slave_write()
             *          slave->slave_write()
             *          insert_state()
             *   Has to be split up by a insert_state() before a new round of slave communications starts.
             *   This is checked by the tool. If something goes wrong a trace is displayed showing the causing error.
             *   insert_state() can be used in any module.
             */

            tasks_in->slave_read(tasks, tasks_in_valid);
            tx_control_in->slave_read(tx_control_resp, tx_control_in_valid);
            rx_control_in->slave_read(rx_control_resp, rx_control_in_valid);
            bus_in->slave_read(bus_request, bus_in_valid);
            //cts_in->slave_read(cts, cts_in_valid);
            


            events.cts = false;
            events.ncts = false;
            //events.cts   = event_triggered_cts(cts_in_valid, cts, hwfc);
            //events.ncts  = event_triggered_ncts(cts_in_valid, cts, hwfc);

            is_bus_write = is_bus_write_transaction(bus_request.trans_type, bus_in_valid);
            bus_response.valid  = is_bus_read_transaction(bus_request.trans_type, bus_in_valid);

            if (is_bus_write) {//is_bus_write_transaction(bus_request.trans_type, bus_in_valid)) {
                //std::cout << "--- CONTROL: WRITE TRANS" << std::endl;
                //insert_state("BUS_WRITE");
                // tasks_internal.start_rx = is_task_bus(bus_request.addr, bus_request.data, ADDR_TASKS_START_RX);
                // tasks_internal.stop_rx  = is_task_bus(bus_request.addr, bus_request.data, ADDR_TASKS_STOP_RX);
                // tasks_internal.start_tx = is_task_bus(bus_request.addr, bus_request.data, ADDR_TASKS_START_TX);
                // tasks_internal.stop_tx  = is_task_bus(bus_request.addr, bus_request.data, ADDR_TASKS_STOP_TX);
                // tasks_internal.suspend  = is_task_bus(bus_request.addr, bus_request.data, ADDR_TASKS_SUSPEND);
                if (bus_request.addr == ADDR_TASKS_START_RX) {
                    tasks_internal.start_rx = read_bus_bit(bus_request.data, 0);
                } else if (bus_request.addr == ADDR_TASKS_STOP_RX) {
                    tasks_internal.stop_rx = read_bus_bit(bus_request.data, 0);
                }

                //registers.error_src = read_bus_data_error_src(bus_request.addr, bus_request.data, registers.error_src);
                //registers.enable    = read_bus_data_enable(bus_request.addr, bus_request.data, registers.enable);
                //registers.config    = read_bus_data_config(bus_request.addr, bus_request.data, registers.config);
                if (bus_request.addr == ADDR_ERROR_SRC) // clear on 1
                {
                    error_src = ERROR_BIT(~bus_request.data & error_src);
                    // error_overrun = error_overrun && !read_bus_bit(bus_request.data, 0);
                    // error_parity  = error_parity  && !read_bus_bit(bus_request.data, 1);
                    // error_framing = error_framing && !read_bus_bit(bus_request.data, 2);
                    // error_break   = error_break   && !read_bus_bit(bus_request.data, 3);
                }
                else if (bus_request.addr == ADDR_ENABLE)
                {
                    enable = ENABLE_BIT(bus_request.data);
                }
                else if (bus_request.addr == ADDR_CONFIG)
                {
                    config = CONFIG_BIT(bus_request.data);
                }

            } 
            else if (bus_response.valid) // BUS READ
            {
                //insert_state("BUS_READ");
                if (bus_request.addr == ADDR_ERROR_SRC)
                {
                    // bus_response.data = write_bus_bit(error_overrun, 0) |
                    //                     write_bus_bit(error_parity, 1) |
                    //                     write_bus_bit(error_framing, 2) |
                    //                     write_bus_bit(error_break, 3);
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
            }
            // EVENTS
            // events.txd_ready = update_event(tx_control_resp.ready, tx_control_in_valid);
            // events.rxd_ready = update_event(rx_control_resp.ready, rx_control_in_valid);
            // events.rx_timeout = update_event(rx_control_resp.timeout, rx_control_in_valid);
            // events.error = update_event(rx_control_resp.error_overrun
            //                             || rx_control_resp.error_parity
            //                             || rx_control_resp.error_framing
            //                             || rx_control_resp.error_break,
            //                             rx_control_in_valid);



            // tasks.start_rx = update_task(tasks.start_rx,
            //                              tasks_in_valid,
            //                              is_task_bus(bus_request.addr, bus_request.data, ADDR_TASKS_START_RX),
            //                              is_bus_write_transaction(bus_request.trans_type, bus_in_valid));
            // tasks.stop_rx = update_task(tasks.stop_rx,
            //                             tasks_in_valid,
            //                             is_task_bus(bus_request.addr, bus_request.data, ADDR_TASKS_STOP_RX),
            //                             is_bus_write_transaction(bus_request.trans_type, bus_in_valid));
            // if (tasks_in_valid)
            // {
            //     tasks_internal.start_rx = tasks_internal.start_rx || tasks.start_rx;
            //     tasks_internal.stop_rx  = tasks_internal.stop_rx  || tasks.stop_rx;
            // }
            // tasks.start_tx = update_task(tasks.start_tx,
            //                              tasks_in_valid,
            //                              is_task_bus(bus_request.addr, bus_request.data, ADDR_TASKS_START_TX),
            //                              is_bus_write_transaction(bus_request.trans_type, bus_in_valid));
            // tasks.stop_tx = update_task(tasks.stop_tx,
            //                             tasks_in_valid,
            //                             is_task_bus(bus_request.addr, bus_request.data, ADDR_TASKS_STOP_TX),
            //                             is_bus_write_transaction(bus_request.trans_type, bus_in_valid));
            // tasks.suspend = update_task(tasks.suspend,
            //                             tasks_in_valid,
            //                             is_task_bus(bus_request.addr, bus_request.data, ADDR_TASKS_SUSPEND),
            //                             is_bus_write_transaction(bus_request.trans_type, bus_in_valid));

            // tx_control_req.active = update_active(tx_control_req.active,
            //                                       tasks_internal.start_tx,// || ((cts == CTS_ACTIVATED) && hwfc),// || cts_enabled_activated(cts, registers.config),
            //                                       tasks.stop_tx || tasks.suspend,// || cts_enabled_deactivated(cts, hwfc),
            //                                       enable);

            // rx_control_req.active = update_active(rx_control_req.active,
            //                                       tasks.start_rx,
            //                                       tasks.stop_rx || tasks.suspend,
            //                                       enable);

            //hwfc_control_req.active = rx_control_req.active && hwfc_enabled(config);

            // Update ERROR_SRC register in case of errors.
            // New errors have priority over clearance
            //if (rx_control_in_valid)
            //{
                // error_src = error_src | ((static_cast<unsigned int> (rx_control_resp.error_overrun)) << 0) |
                //                         ((static_cast<unsigned int> (rx_control_resp.error_parity)) << 1) |
                //                         ((static_cast<unsigned int> (rx_control_resp.error_framing)) << 2) |
                //                         ((static_cast<unsigned int>(rx_control_resp.error_break)) << 3);
                // if (rx_control_resp.error_overrun)      error_src = error_src | ERROR_OVERRUN_MASK;
                // else if (rx_control_resp.error_parity)  error_src = error_src | ERROR_PARITY_MASK;
                // else if (rx_control_resp.error_framing) error_src = error_src | ERROR_FRAMING_MASK;
                // else if (rx_control_resp.error_break)   error_src = error_src | ERROR_BREAK_MASK;
                //error_src = error_src | rx_control_resp.error_src;
                //std::cout << "Control: register ERROR_SRC after update: " << error_src << std::endl;
            //}
            // if (rx_control_in_valid)
            // {
            //     error_overrun = error_overrun || rx_control_resp.error_overrun;
            //     error_parity = error_parity || rx_control_resp.error_parity;
            //     error_framing = error_framing || rx_control_resp.error_framing;
            //     error_break = error_break || rx_control_resp.error_break;
            //     //std::cout << "Control: register ERROR_SRC after update: " << registers.error_src << std::endl;
            // }

            //config_msg.parity        = PARITY_BIT(config) > 0;
            //config_msg.two_stop_bits = STOP_BIT(config) > 0;

            // if (hwfc_enabled(registers.config))
            // {

            //     if (rx_control_req.active && rts == RTS_DEACTIVATED)
            //     {
            //         rts = RTS_ACTIVATED;
            //         rts_out->master_write(rts);
            //     }
            //     else if (rts == RTS_ACTIVATED)
            //     {
            //         rts = RTS_DEACTIVATED;
            //         rts_out->master_write(rts);
            //     }
                
            // }

            // if (events.cts ||
            //     events.ncts ||
            //     events.rxd_ready ||
            //     events.txd_ready ||
            //     events.rx_timeout ||
            //     events.error) {
            //     events_out->master_write(events);
            // }
            //events_out->write(events);
            tx_control_out->slave_write(tx_control_req);
            rx_control_out->slave_write(rx_control_req);
            hwfc_control_out->slave_write(hwfc_control_req);
            bus_out->slave_write(bus_response);
            tx_config_out->slave_write(config_msg);
            rx_config_out->slave_write(config_msg);


        }
    }

private:
    bool cts_enabled_activated(bool cts, bool hwfc_enabled) const {
        return (cts == CTS_ACTIVATED) && hwfc_enabled;
    }

    bool cts_enabled_deactivated(bool cts, bool hwfc_enabled) const {
        return (cts == CTS_DEACTIVATED) && hwfc_enabled;
    }

    bool is_bus_read_transaction(trans_t trans_type, bool valid) const {
        if (valid) return trans_type == READ;
        return false;
    }

    bool is_bus_write_transaction(trans_t trans_type, bool valid) const {
        if (valid) return trans_type == WRITE;
        return false;
    }

    bool parity_enabled(unsigned int config) const {
        return (config & CONFIG_PARITY_MASK) == CONFIG_PARITY_MASK;
    }

    bool two_stop_bits_enabled(unsigned int config) const {
        return (config & CONFIG_STOP_MASK) == CONFIG_STOP_MASK;
    }

    bool hwfc_enabled(unsigned int config) const {
        return (config & CONFIG_HWFC_MASK) == CONFIG_HWFC_MASK;
    }

    bool is_one(unsigned int reg_value) const {
        return reg_value == 1;
    }

    bool is_task_bus(unsigned int bus_addr, unsigned int bus_data, unsigned int addr) const {
        return bus_addr == addr && is_one(bus_data & 1);
    }

    bool event_triggered_cts(bool valid, bool cts, bool hwfc_enabled) const {
        if (valid && hwfc_enabled) return cts == CTS_ACTIVATED;
        return false;
    }

    bool event_triggered_ncts(bool valid, bool cts, bool hwfc_enabled) const {
        if (valid && hwfc_enabled) return cts == CTS_DEACTIVATED;
        return false;
    }

    bool update_active(bool already_active, bool start, bool stop, bool enable) const {
        if (!enable) {
            return false;
        }
        if (already_active) {
            return !(stop) || start;
        }
        return start;
    }

    bool update_task(bool task, bool task_valid, bool bus_task, bool bus_task_valid) const {
        if (task_valid && task) return task;
        if (bus_task_valid && bus_task) return bus_task;
        return false;
    }

    bool update_event(bool event, bool valid) const {
        if (valid) return event;
        return false;
    }

    // Function to SET the event register in case of an event. Returns the previous value if no event was given
    unsigned int set_event(bool event, unsigned int prev_value) const {
        if (event) return EVENT;
        return prev_value;
    }

    unsigned int read_bus_data_event(unsigned int bus_addr, unsigned int bus_data, unsigned int addr, unsigned int prev_value) const {
        if (bus_addr == addr && ((bus_data & EVENT) == NO_EVENT)) // event register is cleared by system bus
        {
            return NO_EVENT;
        }
        return prev_value; // this is not the event you are looking for
    }

    // Rewrite in RTL. NOT(~) is not supported by this version of DeSCAM
    unsigned int read_bus_data_error_src(unsigned int bus_addr, unsigned int bus_data, unsigned int error_src) const {
        if (bus_addr == ADDR_ERROR_SRC) {
            //return (~bus_data & error_src) & ERROR_SRC_MASK;
            // if ((bus_data & ERROR_OVERRUN_MASK) > 0) error_overrun = false;
            // if ((bus_data & ERROR_PARITY_MASK)  > 0) error_parity  = false;
            // if ((bus_data & ERROR_FRAMING_MASK) > 0) error_framing = false;
            // if ((bus_data & ERROR_BREAK_MASK)   > 0) error_break   = false;
        }
        return error_src;
    }

    bool read_bus_data_enable(unsigned int bus_addr, unsigned int bus_data, bool enable) const {
        if (bus_addr == ADDR_ENABLE) {
            //std::cout << "--- CONTROL: Writing " << (bus_request.data & 1) << " to enable" << std::endl;
            return (bus_data & 1) == 1;
        }
        return enable;
    }
    bool read_bus_bit(unsigned int bus_data, unsigned int pos) const
    {
        return (bus_data & (1 << pos)) == 1;
    }

    unsigned int read_bus_data_config(unsigned int bus_addr, unsigned int bus_data, unsigned int config) const {
        if (bus_addr == ADDR_CONFIG) {
            return bus_data & (CONFIG_BIT_MASK);
        }
        return config;
    }


    // unsigned int write_bus_data(unsigned int bus_addr,
    //                             // unsigned int events_cts,
    //                             // unsigned int events_ncts,
    //                             // unsigned int events_rxd_ready,
    //                             // unsigned int events_txd_ready,
    //                             // unsigned int events_error,
    //                             // unsigned int events_rx_timeout,
    //                             unsigned int error_src,
    //                             unsigned int enable,
    //                             unsigned int config) const {
    //     // if (bus_addr == ADDR_EVENTS_CTS) {
    //     //     return events_cts;
    //     // }
    //     // if (bus_addr == ADDR_EVENTS_NCTS) {
    //     //     return events_ncts;
    //     // }
    //     // if (bus_addr == ADDR_EVENTS_RXD_READY) {
    //     //     return events_rxd_ready;
    //     // }
    //     // if (bus_addr == ADDR_EVENTS_TXD_READY) {
    //     //     return events_txd_ready;
    //     // }
    //     // if (bus_addr == ADDR_EVENTS_ERROR) {
    //     //     return events_error;
    //     // }
    //     // if (bus_addr == ADDR_EVENTS_RX_TIMEOUT) {
    //     //     return events_rx_timeout;
    //     // }
    //     if (bus_addr == ADDR_ERROR_SRC) {
    //         //std::cout << "Control: reading error_src " << error_src << std::endl;
    //         return error_src;
    //     }
    //     if (bus_addr == ADDR_ENABLE) {
    //         return enable;
    //     }
    //     if (bus_addr == ADDR_CONFIG) {
    //         return config;
    //     }
    //     return 0;
    // }
    // unsigned int convert_overrun(bool overrun)
    // {
    //     if (overrun) return ERROR_OVERRUN_MASK;
    //     return 0;
    // }
    //     unsigned int convert_parity(bool parity)
    // {
    //     if (parity) return ERROR_parity_MASK;
    //     return 0;
    // }
    //     unsigned int convert_framing(bool framing)
    // {
    //     if (framing) return ERROR_FRAMING_MASK;
    //     return 0;
    // }
    //     unsigned int convert_break(bool error_break)
    // {
    //     if (error_break) return ERROR_BREAK_MASK;
    //     return 0;
    // }
    unsigned int write_bus_bit(bool val, unsigned int pos) const
    {
        if (val) return 1 << pos;
        return 0;
    }

};