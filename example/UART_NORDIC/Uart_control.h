#include "systemc.h"
#include "Interfaces.h"
#include "Uart_types.h"

#define TASK_MASK(x)    (x & 0x1)
#define ERROR_MASK(x)   (x & 0xF)
#define ENABLE_MASK(x)  (x & 0x1)
#define CONFIG_MASK(x)  (x & 0x1F)
#define PARITY_MASK(x)  (x & 0xE)
#define STOP_MASK(x)    (x & 0x1)
#define HWFC_MASK(x)    (x & 0x10)

SC_MODULE(Uart_control) {
    slave_in<bus_req_t> bus_in;
    slave_out<bus_resp_t> bus_out;
    slave_in<tasks_t> tasks_in;
    master_out<events_t> events_out;

    slave_in<bool> cts_in;
    //master_out<bool> rts_out
    slave_out<rx_control_out_t> hwfc_control_out;

    slave_out<tx_control_out_t> tx_control_out;
    slave_in<tx_control_in_t> tx_control_in;
    slave_out<rx_control_out_t> rx_control_out;
    slave_in<rx_control_in_t> rx_control_in;

    slave_out<config_t> rx_config_out;
    slave_out<config_t> tx_config_out;

    bus_req_t bus_in_msg;
    bus_resp_t bus_out_msg;
    tx_control_out_t ctrl_to_tx_msg;
    tx_control_in_t tx_to_ctrl_msg;
    rx_control_out_t ctrl_to_rx_msg;
    rx_control_in_t rx_to_ctrl_msg;
    rx_control_out_t ctrl_to_hwfc_msg;
    tasks_t tasks_in_msg;
    events_t events_out_msg;
    bool cts_in_msg;
    config_t config_msg;

    //bool rts;
    // Valid signals
    bool bus_in_valid;
    bool tasks_in_valid;
    bool tx_control_in_valid;
    bool rx_control_in_valid;
    bool cts_in_valid;
    bool is_bus_write;
    //bool is_bus_read;

    // Registers
    unsigned int error_src;
    unsigned int enable;
    unsigned int config;
    tasks_t tasks_internal;
    bool cts_internal;


    SC_CTOR(Uart_control) :
    //rts(RTS_ACTIVATED),
            cts_in_msg(CTS_DEACTIVATED),
            cts_in_valid(false),
            bus_in_valid(false),
            tx_control_in_valid(false),
            rx_control_in_valid(false),
            tasks_in_valid(false),
            error_src(0),
            enable(0),
            config(0),
            cts_internal(CTS_DEACTIVATED),
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
            cts_in("cts_in")//,
    //rts_out("rts_out")
    {
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

            tasks_in->slave_read(tasks_in_msg, tasks_in_valid);
            tx_control_in->slave_read(tx_to_ctrl_msg, tx_control_in_valid);
            rx_control_in->slave_read(rx_to_ctrl_msg, rx_control_in_valid);
            bus_in->slave_read(bus_in_msg, bus_in_valid);
            cts_in->slave_read(cts_in_msg, cts_in_valid);

            is_bus_write = bus_in_valid && bus_in_msg.trans_type == WRITE;
            bus_out_msg.valid = bus_in_valid && bus_in_msg.trans_type == READ;


//
//            if (is_bus_write)
//            {
            // Task suspend is not included in PS for nRF53 UART
            //tasks_internal.suspend  = is_task_bus(bus_in_msg.addr, bus_in_msg.data, ADDR_tasks_SUSPEND);
            //if (bus_in_msg.addr == ADDR_TASKS_START_RX)        tasks_internal.start_rx = TASK_MASK(bus_in_msg.data) != 0;
//                else if (bus_in_msg.addr == ADDR_TASKS_STOP_RX)    tasks_internal.stop_rx = TASK_MASK(bus_in_msg.data) != 0;
            //else if (bus_in_msg.addr == ADDR_TASKS_START_TX)   tasks_internal.start_tx = TASK_MASK(bus_in_msg.data) != 0;
            //else if (bus_in_msg.addr == ADDR_TASKS_STOP_TX)    tasks_internal.stop_tx = TASK_MASK(bus_in_msg.data) != 0;
            //else if (bus_in_msg.addr == ADDR_ERROR_SRC)        error_src = ERROR_MASK(~bus_in_msg.data & error_src); // clear on 1
            //else if (bus_in_msg.addr == ADDR_ENABLE)           enable = ENABLE_MASK(bus_in_msg.data);
//                else if (bus_in_msg.addr == ADDR_CONFIG)           config = CONFIG_MASK(bus_in_msg.data);
//            }
            // Task suspend is not included in PS for nRF53 UART
            //tasks_internal.suspend  = is_task_bus(bus_in_msg.addr, bus_in_msg.data, ADDR_tasks_SUSPEND);
            //if (bus_in_msg.addr == ADDR_TASKS_START_RX)        tasks_internal.start_rx = TASK_MASK(bus_in_msg.data) != 0;
            tasks_internal.start_rx = (bus_in_msg.addr == ADDR_TASKS_START_RX) ? true : tasks_internal.start_rx;
//                else if (bus_in_msg.addr == ADDR_TASKS_STOP_RX)    tasks_internal.stop_rx = TASK_MASK(bus_in_msg.data) != 0;
            tasks_internal.stop_rx = (bus_in_msg.addr == ADDR_TASKS_STOP_RX && is_bus_write) ? bus_in_msg.data != 0 : tasks_internal.stop_rx;
            //else if (bus_in_msg.addr == ADDR_TASKS_START_TX)   tasks_internal.start_tx = TASK_MASK(bus_in_msg.data) != 0;
            tasks_internal.start_tx = (bus_in_msg.addr == ADDR_TASKS_START_TX && is_bus_write) ? bus_in_msg.data != 0 : tasks_internal.start_tx;
            //else if (bus_in_msg.addr == ADDR_TASKS_STOP_TX)    tasks_internal.stop_tx = TASK_MASK(bus_in_msg.data) != 0;
            tasks_internal.stop_tx = (bus_in_msg.addr == ADDR_TASKS_STOP_TX && is_bus_write) ? bus_in_msg.data != 0 : tasks_internal.start_tx;
            //else if (bus_in_msg.addr == ADDR_ERROR_SRC)        error_src = ERROR_MASK(~bus_in_msg.data & error_src); // clear on 1
            error_src = (bus_in_msg.addr == ADDR_ERROR_SRC && is_bus_write) ? bus_in_msg.data : error_src;
            //else if (bus_in_msg.addr == ADDR_ENABLE)           enable = ENABLE_MASK(bus_in_msg.data);
            enable = (bus_in_msg.addr == ADDR_ENABLE && is_bus_write) ? bus_in_msg.data : enable;
//                else if (bus_CONFIG_MASK(bus_in_msg.data)in_msg.addr == ADDR_CONFIG)           config = CONFIG_MASK(bus_in_msg.data);
            config = (bus_in_msg.addr == ADDR_CONFIG && is_bus_write) ? bus_in_msg.data : config;


//            else if (bus_out_msg.valid) // BUS READ
//            {
            //if (bus_in_msg.addr == ADDR_ERROR_SRC) bus_out_msg.data = error_src;
//                else if (bus_in_msg.addr == ADDR_ENABLE) bus_out_msg.data = enable;
//                else if (bus_in_msg.addr == ADDR_CONFIG) bus_out_msg.data = config;
//            }

            //if (bus_in_msg.addr == ADDR_ERROR_SRC) bus_out_msg.data = error_src;
            bus_out_msg.data = (bus_in_msg.addr == ADDR_ERROR_SRC && bus_out_msg.valid) ? error_src : bus_out_msg.data;
//                else if (bus_in_msg.addr == ADDR_ENABLE) bus_out_msg.data = enable;
            bus_out_msg.data = (bus_in_msg.addr == ADDR_ENABLE && bus_out_msg.valid) ? enable : bus_out_msg.data;
//                else if (bus_in_msg.addr == ADDR_CONFIG) bus_out_msg.data = config;
            bus_out_msg.data = (bus_in_msg.addr == ADDR_CONFIG && bus_out_msg.valid) ? config : bus_out_msg.data;

            // EVENTS
            events_out_msg.txd_ready = update_event(tx_to_ctrl_msg.ready, tx_control_in_valid);
            events_out_msg.rxd_ready = update_event(rx_to_ctrl_msg.ready, rx_control_in_valid);
            events_out_msg.rx_timeout = update_event(rx_to_ctrl_msg.timeout, rx_control_in_valid);
            events_out_msg.error = update_event(rx_to_ctrl_msg.error_src != 0, rx_control_in_valid);
            // TODO: Move cts to another file? Will be located in another clock/power domain
            events_out_msg.cts = event_triggered_cts(cts_in_valid, cts_in_msg, HWFC_MASK(config) != 0);
            events_out_msg.ncts = event_triggered_ncts(cts_in_valid, cts_in_msg, HWFC_MASK(config) != 0);
            //if (HWFC_MASK(config) == 0 || events_out_msg.cts)   cts_internal = CTS_ACTIVATED;
            cts_internal = (HWFC_MASK(config) == 0 || events_out_msg.cts) ? CTS_ACTIVATED : cts_internal;
            //else if (events_out_msg.ncts)                       cts_internal = CTS_DEACTIVATED;
            cts_internal = (!(HWFC_MASK(config) == 0 || events_out_msg.cts) && events_out_msg.ncts) ? CTS_DEACTIVATED : cts_internal;

            // tasks
            tasks_internal.start_rx = tasks_internal.start_rx || (tasks_in_valid && tasks_in_msg.start_rx);
            tasks_internal.stop_rx = tasks_internal.stop_rx || (tasks_in_valid && tasks_in_msg.stop_rx);
            tasks_internal.start_tx = tasks_internal.start_tx || (tasks_in_valid && tasks_in_msg.start_tx) || events_out_msg.cts;
            tasks_internal.stop_tx = tasks_internal.stop_tx || (tasks_in_valid && tasks_in_msg.stop_tx) || events_out_msg.ncts;

            ctrl_to_tx_msg.active = update_active(ctrl_to_tx_msg.active,
                                                  tasks_internal.start_tx,
                                                  tasks_internal.stop_tx,
                                                  (ENABLE_MASK(enable) != 0) && cts_internal == CTS_ACTIVATED); // cts is activated also when hwfc is off

            ctrl_to_rx_msg.active = update_active(ctrl_to_rx_msg.active,
                                                  tasks_internal.start_rx,
                                                  tasks_internal.stop_rx,
                                                  ENABLE_MASK(enable) != 0);

            ctrl_to_hwfc_msg.active = ctrl_to_rx_msg.active && (HWFC_MASK(config) != 0);

            // Update ERROR_SRC register in case of errors.
            // New errors have priority over clearance
//            if (rx_control_in_valid)
//            {
//                error_src = error_src | rx_to_ctrl_msg.error_src;
//                // if (rx_to_ctrl_msg.error_overrun)      error_src = error_src | ERROR_OVERRUN_MASK;
//                // else if (rx_to_ctrl_msg.error_parity)  error_src = error_src | ERROR_PARITY_MASK;
//                // else if (rx_to_ctrl_msg.error_framing) error_src = error_src | ERROR_FRAMING_MASK;
//                // else if (rx_to_ctrl_msg.error_break)   error_src = error_src | ERROR_BREAK_MASK;
//
//                //std::cout << "Control: register ERROR_SRC after update: " << error_src << std::endl;
//            }
            error_src = (rx_control_in_valid) ? error_src | rx_to_ctrl_msg.error_src : error_src;

            config_msg.parity = PARITY_MASK(config) != 0;
            config_msg.two_stop_bits = STOP_MASK(config) != 0;

            // Consider moving back here
            // if (hwfc_enabled(registers.config))
            // {

            //     if (ctrl_to_rx_msg.active && rts == RTS_DEACTIVATED)
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

            if (events_out_msg.cts ||
                events_out_msg.ncts ||
                events_out_msg.rxd_ready ||
                events_out_msg.txd_ready ||
                events_out_msg.rx_timeout ||
                events_out_msg.error) {
                events_out->master_write(events_out_msg);
            }
            tx_control_out->slave_write(ctrl_to_tx_msg);
            rx_control_out->slave_write(ctrl_to_rx_msg);
            hwfc_control_out->slave_write(ctrl_to_hwfc_msg);
            bus_out->slave_write(bus_out_msg);
            tx_config_out->slave_write(config_msg);
            rx_config_out->slave_write(config_msg);

        }
    }

private:

    bool event_triggered_cts(bool valid, bool cts, bool hwfc_enabled) const {
        if (valid && hwfc_enabled) return cts == CTS_ACTIVATED;
        return false;
    }

    bool event_triggered_ncts(bool valid, bool cts, bool hwfc_enabled) const {
        if (valid && hwfc_enabled) return cts == CTS_DEACTIVATED;
        return false;
    }

    bool update_active(bool already_active, bool start, bool stop, bool enabled) const {
        if (!enabled) {
            return false;
        } else if (already_active) {
            if(stop == false ){
                return true;
            }else return start;
        }
        return start;
    }

    bool update_event(bool event, bool valid) const {
        if (valid) return event;
        return false;
    }

};