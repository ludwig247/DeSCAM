#include "systemc.h"
#include "Interfaces.h"
#include "Uart_types.h"

#define TASK_MASK(x)        (x & 1)
#define ERROR_MASK(x)       (x & 0xF)
#define ENABLE_MASK(x)      (x & 1)
#define CONFIG_MASK(x)      (x & 0x1F)
#define PARITY_MASK(x)      (x & 0xE)
#define STOP_MASK(x)        (x & 0x1)
#define HWFC_MASK(x)        (x & 0x10)
#define ODD_PARITY_MASK(x)  (x & 0x100)

#define BOOL(x) ((x & 1) != 0)


SC_MODULE(Uart_control) {
    slave_in<bus_req_t>     bus_in;
    slave_out<bus_resp_t>   bus_out;
    slave_in<tasks_t>       tasks_in;
    master_out<events_t>    events_out;

    slave_in<bool> cts_in;
    //master_out<bool> rts_out;
    //slave_out<bool> hwfc_control_out;

    // TX control and config
    shared_out<bool>        tx_active_out;
    shared_out<config_t>    tx_config_out;
    // TX events
    slave_in<tx_events_t>   tx_events_in;

    // RX control and config
    shared_out<bool>       rx_active_out;
    shared_out<config_t>   rx_config_out;
    // RX events
    slave_in<rx_events_t>  rx_events_in;
    

    bus_req_t           bus_in_msg;
    bus_resp_t          bus_out_msg;
    bool                ctrl_to_hwfc_msg;

    bool            tx_active_out_msg;
    tx_events_t     tx_events_msg;

    bool            rx_active_out_msg;
    rx_events_t     rx_events_msg;


    tasks_t             tasks_in_msg;
    events_t            events_out_msg;
    bool                cts_in_msg;
    config_t            config_msg;
    

    // "Valid" signals
    bool bus_in_valid;
    bool tasks_in_valid;
    bool cts_in_valid;
    bool bus_wr;
    bool bus_rd;
    bool rx_error_valid;
    bool tx_events_valid;
    bool rx_events_valid;

    // Visible registers
    unsigned int error_src;
    unsigned int enable;
    unsigned int config;
    tasks_t      tasks;
    bool         cts_internal;

    //bool enabled;

#ifdef SIM
    bool rx_active_prev;
    bool tx_active_prev;
#endif


    SC_CTOR(Uart_control) :
            //rts(RTS_ACTIVATED),
            cts_in_msg(CTS_DEACTIVATED),
            cts_in_valid(false),
            bus_in_valid(false),
            tasks_in_valid(false),
            error_src(0),
            enable(0),
            //enabled(0),
            config(0),
#ifdef SIM
            rx_active_prev(false),
            tx_active_prev(false),
#endif
            cts_internal(CTS_DEACTIVATED),
            bus_in("bus_in"),
            bus_out("bus_out"),
            tx_events_in("tx_events_in"),
            rx_events_in("rx_events_in"),
            tx_active_out("tx_active_out"),
            rx_active_out("rx_active_out"),
            //tx_is_transmitting_in("tx_is_transmitting"),
            //hwfc_control_out("hwfc_control_out"),
            tasks_in("tasks"),
            events_out("events"),
            tx_config_out("tx_config_out"),
            rx_config_out("rx_config_out"),
            bus_wr(false),
            bus_rd(false),
            cts_in("cts_in")//,
            //rts_out("rts_out") 
            {
        SC_THREAD(fsm);
    }

    void fsm();
private:

    // bool event_triggered_cts(bool valid, bool cts, bool hwfc_enabled) const {
    //     if (valid && hwfc_enabled) return cts == CTS_ACTIVATED;
    //     return false;
    // }

    // bool event_triggered_ncts(bool valid, bool cts, bool hwfc_enabled) const {
    //     if (valid && hwfc_enabled) return cts == CTS_DEACTIVATED;
    //     return false;
    // }

    // bool update_active(bool already_active, bool start, bool stop, bool enabled) const {
    //     //if (!enabled) {
    //     //    return false;
    //     //}
    //     //else if (already_active) {
    //     //    return !(stop) || start;
    //     //} else return start;
    //     return enabled && (start || (already_active && !(stop)));
    // }

};

void Uart_control::fsm()
{
    while (true) {
        insert_state("conceptual_state");
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
        bus_in->slave_read(bus_in_msg, bus_in_valid);
        cts_in->slave_read(cts_in_msg, cts_in_valid);

        tx_events_in->slave_read(tx_events_msg, tx_events_valid);
        rx_events_in->slave_read(rx_events_msg, rx_events_valid);

        bus_wr = bus_in_valid && bus_in_msg.trans_type == WRITE;
        bus_rd = bus_in_valid && bus_in_msg.trans_type == READ;
        bus_out_msg.valid = bus_rd;

        // Task suspend is not included in PS for nRF53 UART
        //tasks_internal.suspend  = is_task_bus(bus_in_msg.addr, bus_in_msg.data, ADDR_tasks_SUSPEND);
        // BUS WRITE
        tasks.start_rx = (bus_wr && (bus_in_msg.addr == ADDR_TASKS_START_RX)) ? (TASK_MASK(bus_in_msg.data) != 0) : false;
        tasks.stop_rx  = (bus_wr && (bus_in_msg.addr == ADDR_TASKS_STOP_RX))  ? (TASK_MASK(bus_in_msg.data) != 0) : false;
        tasks.start_tx = (bus_wr && (bus_in_msg.addr == ADDR_TASKS_START_TX)) ? (TASK_MASK(bus_in_msg.data) != 0) : false;
        tasks.stop_tx  = (bus_wr && (bus_in_msg.addr == ADDR_TASKS_STOP_TX))  ? (TASK_MASK(bus_in_msg.data) != 0) : false;
        error_src      = (bus_wr && (bus_in_msg.addr == ADDR_ERROR_SRC))      ? (ERROR_MASK(~bus_in_msg.data & error_src)) : error_src;
        enable         = (bus_wr && (bus_in_msg.addr == ADDR_ENABLE))         ? (ENABLE_MASK(bus_in_msg.data))             : enable;
        config         = (bus_wr && (bus_in_msg.addr == ADDR_CONFIG))         ? (CONFIG_MASK(bus_in_msg.data))             : config;
        //enabled = ENABLE_MASK(enable) != 0;

        // BUS READ
        bus_out_msg.data = (bus_rd && bus_in_msg.addr == ADDR_ERROR_SRC) ? error_src : bus_out_msg.data;
        bus_out_msg.data = (bus_rd && bus_in_msg.addr == ADDR_ENABLE)    ? enable    : bus_out_msg.data;
        bus_out_msg.data = (bus_rd && bus_in_msg.addr == ADDR_CONFIG)    ? config    : bus_out_msg.data;

        // EVENTS
        events_out_msg.txd_ready   = ((ENABLE_MASK(enable) != 0) && tx_events_valid) ? tx_events_msg.done             : false;
        events_out_msg.rxd_ready   = ((ENABLE_MASK(enable) != 0) && rx_events_valid) ? rx_events_msg.ready            : false;
        events_out_msg.rx_timeout  = ((ENABLE_MASK(enable) != 0) && rx_events_valid) ? rx_events_msg.timeout          : false;
        events_out_msg.error       = ((ENABLE_MASK(enable) != 0) && rx_events_valid) ? (rx_events_msg.error_src != 0) : false;
        //events_out_msg.txd_ready  = update_event(tx_events_msg.done, tx_events_valid);
        // events_out_msg.rxd_ready  = update_event(rx_events_msg.ready, rx_events_valid);
        // events_out_msg.rx_timeout = update_event(rx_events_msg.timeout, rx_events_valid);
        // events_out_msg.error      = update_event(rx_events_msg.error_src != 0, rx_events_valid);
        // TODO: Move cts to another file? Will be located in another clock/power domain
        //events_out_msg.cts   = event_triggered_cts(cts_in_valid, cts_in_msg, HWFC_MASK(config) != 0);
        events_out_msg.cts  = ((ENABLE_MASK(enable) != 0) && (HWFC_MASK(config) != 0) && cts_in_valid) ? cts_in_msg == CTS_ACTIVATED   : false;
        events_out_msg.ncts = ((ENABLE_MASK(enable) != 0) && (HWFC_MASK(config) != 0) && cts_in_valid) ? cts_in_msg == CTS_DEACTIVATED : false;
        //events_out_msg.ncts  = event_triggered_ncts(cts_in_valid, cts_in_msg, HWFC_MASK(config) != 0);

        if (HWFC_MASK(config) == 0 || events_out_msg.cts)   cts_internal = CTS_ACTIVATED;
        else if (events_out_msg.ncts)                       cts_internal = CTS_DEACTIVATED;

        // TASKS
        tasks.start_rx = tasks.start_rx || (tasks_in_valid && tasks_in_msg.start_rx);
        tasks.stop_rx  = tasks.stop_rx  || (tasks_in_valid && tasks_in_msg.stop_rx);
        tasks.start_tx = tasks.start_tx || (tasks_in_valid && tasks_in_msg.start_tx) || events_out_msg.cts;
        tasks.stop_tx  = tasks.stop_tx  || (tasks_in_valid && tasks_in_msg.stop_tx) || events_out_msg.ncts;

        // tx_active_out_msg = update_active(tx_active_out_msg,
        //                                   tasks.start_tx,
        //                                   tasks.stop_tx,
        //                                   (ENABLE_MASK(enable) != 0) && cts_internal == CTS_ACTIVATED); // cts is activated also when hwfc is off

        // rx_active_out_msg = update_active(rx_active_out_msg,
        //                                   tasks.start_rx,
        //                                   tasks.stop_rx,
        //                                   ENABLE_MASK(enable) != 0);
        tx_active_out_msg = BOOL(enable) && (tasks.start_tx || (tx_active_out_msg && !(tasks.stop_tx)));

        rx_active_out_msg = BOOL(enable) && (tasks.start_rx || (rx_active_out_msg && !(tasks.stop_rx)));


#ifdef SIM
        if ((tx_active_out_msg != tx_active_prev) && tx_active_out_msg) debug_print(CONTROL, "TX status change! TX now ON");
        if ((tx_active_out_msg != tx_active_prev) && !tx_active_out_msg) debug_print(CONTROL, "TX status change! TX now OFF");
        if ((rx_active_out_msg != rx_active_prev) && rx_active_out_msg) debug_print(CONTROL, "RX status change! RX now ON");
        if ((rx_active_out_msg != rx_active_prev) && !rx_active_out_msg) debug_print(CONTROL, "RX status change! RX now OFF");
        tx_active_prev = tx_active_out_msg;
        rx_active_prev = rx_active_out_msg;
#endif

        ctrl_to_hwfc_msg = rx_active_out_msg && (HWFC_MASK(config) != 0);

        // Update ERROR_SRC register in case of errors.
        // New errors have priority over clearance
        error_src = rx_events_valid ? error_src | rx_events_msg.error_src : error_src;
        //if (rx_events_valid)
        //{
            //error_src = error_src | rx_events_msg.error_src;
            // if (rx_to_ctrl_msg.error_overrun)      error_src = error_src | ERROR_OVERRUN_MASK;
            // else if (rx_to_ctrl_msg.error_parity)  error_src = error_src | ERROR_PARITY_MASK;
            // else if (rx_to_ctrl_msg.error_framing) error_src = error_src | ERROR_FRAMING_MASK;
            // else if (rx_to_ctrl_msg.error_break)   error_src = error_src | ERROR_BREAK_MASK;
            
            //std::cout << "Control: register ERROR_SRC after update: " << error_src << std::endl;
        //}

        config_msg.parity        = PARITY_MASK(config) != 0;
        config_msg.two_stop_bits = STOP_MASK(config) != 0;
        config_msg.odd_parity    = ODD_PARITY_MASK(config) != 0;

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

        if (events_out_msg.cts          ||
            events_out_msg.ncts         ||
            events_out_msg.rxd_ready    ||
            events_out_msg.txd_ready    ||
            events_out_msg.rx_timeout   ||
            events_out_msg.error) 
        {
            events_out->master_write(events_out_msg);
        }
        tx_active_out->set(tx_active_out_msg);
        rx_active_out->set(rx_active_out_msg);
        //hwfc_control_out->slave_write(ctrl_to_hwfc_msg);
        bus_out->slave_write(bus_out_msg);
        tx_config_out->set(config_msg);
        rx_config_out->set(config_msg);

    }
}