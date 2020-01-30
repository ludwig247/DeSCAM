#include "systemc.h"
#include "Interfaces.h"
#include "Uart_types.h"

SC_MODULE(Uart_control) {
    slave_in<bus_req_t> bus_in;
    slave_out<bus_resp_t> bus_out;
    slave_in<tasks_t> tasks_in;
    master_out<events_t> events_out;

    slave_in<bool> cts_in;
    master_out<bool> rts_out;

    slave_out<tx_control_out_t> tx_control_out;
    slave_in<tx_control_in_t> tx_control_in;
    slave_out<rx_control_out_t> rx_control_out;
    slave_in<rx_control_in_t> rx_control_in;

    slave_out<config_t> rx_config_out; // Have only one output?
    slave_out<config_t> tx_config_out;

    bus_req_t bus_request;
    bus_resp_t bus_response;
    config_t config_msg;
    tx_control_out_t tx_control_req;
    tx_control_in_t tx_control_resp;
    rx_control_out_t rx_control_req;
    rx_control_in_t rx_control_resp;
    tasks_t tasks;
    tasks_t tasks_internal;
    events_t events;
    bool cts;
    bool cts_in_valid;
    bool rts;
    bool ongoing_bus_transaction;
    bool tasks_in_valid;
    bool tx_control_in_valid;
    bool rx_control_in_valid;


    // Registers
    registers_t registers;

    SC_CTOR(Uart_control) :
            rts(RTS_DEACTIVATED),
            cts(CTS_DEACTIVATED),
            cts_in_valid(false),
            ongoing_bus_transaction(false),
            tx_control_in_valid(false),
            rx_control_in_valid(false),
            tasks_in_valid(false),
            bus_in("bus_in"),
            bus_out("bus_out"),
            tx_control_in("tx_control_in"),
            tx_control_out("tx_control_out"),
            rx_control_in("rx_control_in"),
            rx_control_out("rx_control_out"),
            tasks_in("tasks"),
            events_out("events"),
            tx_config_out("tx_config_out"),
            rx_config_out("rx_config_out"),
            cts_in("cts_in"),
            rts_out("rts_out") {
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
            bus_in->slave_read(bus_request, ongoing_bus_transaction);
            cts_in->slave_read(cts, cts_in_valid);

            events.cts = false;
            events.ncts = false;
            //events.cts        = event_triggered_cts(cts_in_valid, cts, registers.config);
            //events.ncts       = event_triggered_ncts(cts_in_valid, cts, registers.config);

            if (is_bus_write_transaction(bus_request.trans_type, ongoing_bus_transaction)) {
                //std::cout << "--- CONTROL: WRITE TRANS" << std::endl;
                tasks_internal.start_rx = is_task_bus(bus_request.addr, bus_request.data, ADDR_TASKS_START_RX());
                tasks_internal.stop_rx = is_task_bus(bus_request.addr, bus_request.data, ADDR_TASKS_STOP_RX());
                tasks_internal.start_tx = is_task_bus(bus_request.addr, bus_request.data, ADDR_TASKS_START_TX());
                tasks_internal.stop_tx = is_task_bus(bus_request.addr, bus_request.data, ADDR_TASKS_STOP_TX());
                tasks_internal.suspend = is_task_bus(bus_request.addr, bus_request.data, ADDR_TASKS_SUSPEND());

                //registers.events_cts        = read_bus_data_event(bus_request.addr, bus_request.data, ADDR_EVENTS_CTS(), registers.events_cts);
                //registers.events_ncts       = read_bus_data_event(bus_request.addr, bus_request.data, ADDR_EVENTS_NCTS(), registers.events_ncts);
                registers.events_cts = 0;//read_bus_data_event(bus_request.addr, bus_request.data, ADDR_EVENTS_CTS(), registers.events_cts);
                registers.events_ncts = 0;//read_bus_data_event(bus_request.addr, bus_request.data, ADDR_EVENTS_NCTS(), registers.events_ncts);
                registers.events_rxd_ready = read_bus_data_event(bus_request.addr, bus_request.data, ADDR_EVENTS_RXD_READY(), registers.events_rxd_ready);
                registers.events_txd_ready = read_bus_data_event(bus_request.addr, bus_request.data, ADDR_EVENTS_TXD_READY(), registers.events_txd_ready);
                registers.events_rx_timeout = read_bus_data_event(bus_request.addr, bus_request.data, ADDR_EVENTS_RX_TIMEOUT(), registers.events_rx_timeout);
                registers.events_error = read_bus_data_event(bus_request.addr, bus_request.data, ADDR_EVENTS_ERROR(), registers.events_error);

                registers.error_src = read_bus_data_error_src(bus_request.addr, bus_request.data, registers.error_src);
                registers.enable = read_bus_data_enable(bus_request.addr, bus_request.data, registers.enable);
                registers.config = read_bus_data_config(bus_request.addr, bus_request.data, registers.config);
                config_msg.parity = parity_enabled(registers.config);
                config_msg.two_stop_bits = two_stop_bits_enabled(registers.config);
            } else if (is_bus_read_transaction(bus_request.trans_type, ongoing_bus_transaction)) {
                bus_response.data = write_bus_data(bus_request.addr,
                                                   registers.events_cts,
                                                   registers.events_ncts,
                                                   registers.events_rxd_ready,
                                                   registers.events_txd_ready,
                                                   registers.events_error,
                                                   registers.events_rx_timeout,
                                                   registers.error_src,
                                                   registers.enable,
                                                   registers.config);
            }
            events.txd_ready = update_event(tx_control_resp.ready, tx_control_in_valid);
            registers.events_txd_ready = set_event(tx_control_resp.ready, registers.events_txd_ready);

            events.rxd_ready = update_event(rx_control_resp.ready, rx_control_in_valid);
            events.rx_timeout = update_event(rx_control_resp.timeout, rx_control_in_valid);
            events.error = update_event(rx_control_resp.error_overrun
                                        || rx_control_resp.error_parity
                                        || rx_control_resp.error_framing
                                        || rx_control_resp.error_break,
                                        rx_control_in_valid);
            registers.events_rxd_ready = set_event(events.rxd_ready, registers.events_rxd_ready);
            registers.events_rx_timeout = set_event(events.rx_timeout, registers.events_rxd_ready);
            registers.events_error = set_event(events.error, registers.events_error);

            tasks.start_rx = update_task(tasks.start_rx,
                                         tasks_in_valid,
                                         is_task_bus(bus_request.addr, bus_request.data, ADDR_TASKS_START_RX()),
                                         is_bus_write_transaction(bus_request.trans_type, ongoing_bus_transaction));
            tasks.stop_rx = update_task(tasks.stop_rx,
                                        tasks_in_valid,
                                        is_task_bus(bus_request.addr, bus_request.data, ADDR_TASKS_STOP_RX()),
                                        is_bus_write_transaction(bus_request.trans_type, ongoing_bus_transaction));
            tasks.start_tx = update_task(tasks.start_tx,
                                         tasks_in_valid,
                                         is_task_bus(bus_request.addr, bus_request.data, ADDR_TASKS_START_TX()),
                                         is_bus_write_transaction(bus_request.trans_type, ongoing_bus_transaction));
            tasks.stop_tx = update_task(tasks.stop_tx,
                                        tasks_in_valid,
                                        is_task_bus(bus_request.addr, bus_request.data, ADDR_TASKS_STOP_TX()),
                                        is_bus_write_transaction(bus_request.trans_type, ongoing_bus_transaction));
            tasks.suspend = update_task(tasks.suspend,
                                        tasks_in_valid,
                                        is_task_bus(bus_request.addr, bus_request.data, ADDR_TASKS_SUSPEND()),
                                        is_bus_write_transaction(bus_request.trans_type, ongoing_bus_transaction));

            tx_control_req.active = update_active(tx_control_req.active,
                                                  tasks.start_tx,// || cts_enabled_activated(cts, registers.config),
                                                  tasks.stop_tx || tasks.suspend,// || cts_enabled_deactivated(cts, registers.config),
                                                  registers.enable);

            rx_control_req.active = update_active(rx_control_req.active,
                                                  tasks.start_rx,
                                                  tasks.stop_rx || tasks.suspend,
                                                  registers.enable);

            // if (hwfc_enabled(registers.config))
            // {

            //     if (rx_control_req.active)
            //     {
            //         rts = RTS_ACTIVATED;
            //     }
            //     else
            //     {
            //         rts = RTS_DEACTIVATED;
            //     }
            //     rts_out->write(rts);
            // }

            bus_response.valid = is_bus_read_transaction(bus_request.trans_type, ongoing_bus_transaction);

            if (events.cts ||
                events.ncts ||
                events.rxd_ready ||
                events.txd_ready ||
                events.rx_timeout ||
                events.error) {
                events_out->master_write(events);
            }
            //events_out->write(events);
            tx_control_out->slave_write(tx_control_req);
            rx_control_out->slave_write(rx_control_req);
            bus_out->slave_write(bus_response);
            tx_config_out->slave_write(config_msg);
            rx_config_out->slave_write(config_msg);
        }
    }

private:
    bool cts_enabled_activated(bool cts, unsigned int config) const {
        return (cts == CTS_ACTIVATED) && hwfc_enabled(config);
    }

    bool cts_enabled_deactivated(bool cts, unsigned int config) const {
        return (cts == CTS_DEACTIVATED) && hwfc_enabled(config);
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
        return (config & CONFIG_PARITY_MASK()) == CONFIG_PARITY_MASK();
    }

    bool two_stop_bits_enabled(unsigned int config) const {
        return (config & CONFIG_STOP_MASK()) == CONFIG_STOP_MASK();
    }

    bool hwfc_enabled(unsigned int config) const {
        return (config & CONFIG_HWFC_MASK()) == CONFIG_HWFC_MASK();
    }

    bool is_one(unsigned int reg_value) const {
        return reg_value == 1;
    }

    bool is_task_bus(unsigned int bus_addr, unsigned int bus_data, unsigned int addr) const {
        return bus_addr == addr && is_one(bus_data & 1);
    }

    bool event_triggered_cts(bool valid, bool cts, unsigned int config) const {
        if (valid && hwfc_enabled(config)) return cts == CTS_ACTIVATED;
        return false;
    }

    bool event_triggered_ncts(bool valid, bool cts, unsigned int config) const {
        if (valid && hwfc_enabled(config)) return cts == CTS_DEACTIVATED;
        return false;
    }

    bool update_active(bool already_active, bool start, bool stop, unsigned int enable) const {
        if (!is_one(enable)) {
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
        if (bus_addr == ADDR_ERROR_SRC()) {
            return bus_data;
        }
        return error_src;
    }

    unsigned int read_bus_data_enable(unsigned int bus_addr, unsigned int bus_data, unsigned int enable) const {
        if (bus_addr == ADDR_ENABLE()) {
            //std::cout << "--- CONTROL: Writing " << (bus_request.data & 1) << " to enable" << std::endl;
            return bus_data & 1;
        }
        return enable;
    }

    unsigned int read_bus_data_config(unsigned int bus_addr, unsigned int bus_data, unsigned int config) const {
        if (bus_addr == ADDR_CONFIG()) {
            return bus_data & (CONFIG_BIT_MASK());
        }
        return config;
    }


    unsigned int write_bus_data(unsigned int bus_addr,
                                unsigned int events_cts,
                                unsigned int events_ncts,
                                unsigned int events_rxd_ready,
                                unsigned int events_txd_ready,
                                unsigned int events_error,
                                unsigned int events_rx_timeout,
                                unsigned int error_src,
                                unsigned int enable,
                                unsigned int config) const {
        if (bus_addr == ADDR_EVENTS_CTS()) {
            return events_cts;
        }
        if (bus_addr == ADDR_EVENTS_NCTS()) {
            return events_ncts;
        }
        if (bus_addr == ADDR_EVENTS_RXD_READY()) {
            return events_rxd_ready;
        }
        if (bus_addr == ADDR_EVENTS_TXD_READY()) {
            return events_txd_ready;
        }
        if (bus_addr == ADDR_EVENTS_ERROR()) {
            return events_error;
        }
        if (bus_addr == ADDR_EVENTS_RX_TIMEOUT()) {
            return events_rx_timeout;
        }
        if (bus_addr == ADDR_ERROR_SRC()) {
            return error_src;
        }
        if (bus_addr == ADDR_ENABLE()) {
            return enable;
        }
        if (bus_addr == ADDR_CONFIG()) {
            return config;
        }
        return 0;
    }

    unsigned int ADDR_TASKS_START_RX() const { return ADDR_TASKS_START_RX_T; }

    unsigned int ADDR_TASKS_STOP_RX() const { return ADDR_TASKS_STOP_RX_T; }

    unsigned int ADDR_TASKS_START_TX() const { return ADDR_TASKS_START_TX_T; }

    unsigned int ADDR_TASKS_STOP_TX() const { return ADDR_TASKS_STOP_TX_T; }

    unsigned int ADDR_TASKS_SUSPEND() const { return ADDR_TASKS_SUSPEND_T; }

    unsigned int ADDR_EVENTS_CTS() const { return ADDR_EVENTS_CTS_T; }

    unsigned int ADDR_EVENTS_NCTS() const { return ADDR_EVENTS_NCTS_T; }

    unsigned int ADDR_EVENTS_RXD_READY() const { return ADDR_EVENTS_RXD_READY_T; }

    unsigned int ADDR_EVENTS_TXD_READY() const { return ADDR_EVENTS_TXD_READY_T; }

    unsigned int ADDR_EVENTS_ERROR() const { return ADDR_EVENTS_ERROR_T; }

    unsigned int ADDR_EVENTS_RX_TIMEOUT() const { return ADDR_EVENTS_RX_TIMEOUT_T; }

    unsigned int ADDR_ERROR_SRC() const { return ADDR_ERROR_SRC_T; }

    unsigned int ERROR_OVERRUN_MASK() const { return ERROR_OVERRUN_MASK_T; }

    unsigned int ERROR_OVERRUN_MASK_INV() const { return ERROR_OVERRUN_MASK_T; } // should be INV!
    unsigned int ERROR_PARITY_MASK() const { return ERROR_PARITY_MASK_T; }

    unsigned int ERROR_PARITY_MASK_INV() const { return ERROR_PARITY_MASK_T; } // should be INV!
    unsigned int ERROR_FRAMING_MASK() const { return ERROR_FRAMING_MASK_T; }

    unsigned int ERROR_FRAMING_MASK_INV() const { return ERROR_FRAMING_MASK_T; } // should be INV!
    unsigned int ERROR_BREAK_MASK() const { return ERROR_BREAK_MASK_T; }

    unsigned int ERROR_BREAK_MASK_INV() const { return ERROR_BREAK_MASK_T; } // should be INV!
    unsigned int ERROR_SRC_MASK() const { return ERROR_SRC_MASK_T; }

    unsigned int ADDR_ENABLE() const { return ADDR_ENABLE_T; }

    unsigned int ADDR_CONFIG() const { return ADDR_CONFIG_T; }

    unsigned int CONFIG_STOP_MASK() const { return CONFIG_STOP_MASK_T; }

    unsigned int CONFIG_STOP_BIT_OFFSET() const { return CONFIG_STOP_BIT_OFFSET_T; }

    unsigned int CONFIG_PARITY_MASK() const { return CONFIG_PARITY_MASK_T; }

    unsigned int CONFIG_PARITY_BIT_OFFSET() const { return CONFIG_PARITY_BIT_OFFSET_T; }

    unsigned int CONFIG_HWFC_MASK() const { return CONFIG_HWFC_MASK_T; }

    unsigned int CONFIG_HWFC_BIT_OFFSET() const { return CONFIG_HWFC_BIT_OFFSET_T; }

    unsigned int CONFIG_BIT_MASK() const { return CONFIG_BIT_MASK_T; }

};