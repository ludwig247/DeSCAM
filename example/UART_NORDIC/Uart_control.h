#include "systemc.h"
#include "Interfaces.h"
#include "Uart_types.h"

// #define TASK_MASK(x)        ((x & 1) != 0)
// #define ERROR_MASK(x)       (x & 0xF)
// #define ENABLE_MASK(x)      (x & 1)
// #define CONFIG_MASK(x)      (x & 0x1F)
// #define PARITY(x)      ((x & 0xE) != 0)
// #define STOP(x)        ((x & 0x1) != 0)
// #define HWFC(x)        ((x & 0x10) != 0)
// #define ODD_PARITY(x)  ((x & 0x100) != 0)

// #define ENABLE(x) ((x & 1) != 0)


SC_MODULE(Uart_control) {
    slave_in<bus_req_t>     bus_in;
    slave_out<bus_resp_t>   bus_out;
    slave_in<tasks_t>       tasks_in;
    master_out<events_t>    events_out;

    slave_in<bool> cts_in;
    master_out<bool> rts_out;
    //slave_out<bool> hwfc_control_out;

    // TX control and config
    shared_out<bool>        tx_active_out;
    shared_out<config_t>    tx_config_out;
    // TX events
    slave_in<tx_events_t>   tx_events_in;

    // RX control and config
    shared_out<bool>       rx_active_out;
#ifdef SIM    
    shared_out<config_t>   rx_config_out; 
#endif
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

    // Tmp registers
    unsigned int error_src_tmp;
    unsigned int bus_data_tmp;

    // Visible registers
    unsigned int error_src;
    unsigned int enable;
    unsigned int frame_config;
    tasks_t      tasks;
    bool         cts_internal;
    bool         rts_internal;

    //bool enabled;

#ifdef SIM
    bool rx_active_prev;
    bool tx_active_prev;
#endif


    SC_CTOR(Uart_control) :

            cts_in_msg(CTS_DEACTIVATED),
            cts_in_valid(false),
            bus_in_valid(false),
            tasks_in_valid(false),
            error_src(0),
            enable(0),
            //enabled(0),
            frame_config(0),
#ifdef SIM
            rx_active_prev(false),
            tx_active_prev(false),
#endif
            cts_internal(CTS_DEACTIVATED),
            rts_internal(RTS_ACTIVATED),
            bus_in("bus_in"),
            bus_out("bus_out"),
            tx_events_in("tx_events_in"),
            rx_events_in("rx_events_in"),
            tx_active_out("tx_active_out"),
            rx_active_out("rx_active_out"),
            tasks_in("tasks"),
            events_out("events"),
            tx_config_out("tx_config_out"),
#ifdef SIM
            rx_config_out("rx_config_out"),
#endif
            bus_wr(false),
            bus_rd(false),
            cts_in("cts_in"),
            rts_out("rts_out")
            {
        SC_THREAD(fsm);
    }

    bool ENABLE(unsigned int enable) const
    {
        return (enable & 1) != 0;
    }

    bool TASK_MASK(unsigned int task) const
    {
        return (task & 1) != 0;
    }

    unsigned int ERROR_MASK(unsigned int error_src) const {return (error_src & 0xF);}

    unsigned int ENABLE_MASK(unsigned int enable) const
    {
        return (enable & 1);
    }

    unsigned int CONFIG_MASK(unsigned int frame_config) const {return (frame_config & 0x1F);}

    bool PARITY(unsigned int parity) const {return (parity & 0xE) != 0;}
    bool STOP(unsigned int stop_bit) const {return (stop_bit & 0x1) != 0;}

    bool HWFC(unsigned int hwfc) const {return (hwfc & 0x10) != 0;}

    bool ODD_PARITY(unsigned int odd_parity) const {return (odd_parity & 0x100) != 0;}

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
    rx_active_out_msg = false;
    tx_active_out_msg = false;
    tx_active_out->set(tx_active_out_msg);
    rx_active_out->set(rx_active_out_msg);
    while (true) {
        insert_state("conceptual_state");
        bus_in_msg.addr = 0;
        bus_in_msg.data = 0;
        bus_in_msg.trans_type = READ;
        //bus_out_msg.data = 0;
        bus_out_msg.valid = false;
        tasks_in_msg.start_rx = false;
        tasks_in_msg.stop_rx = false;
        tasks_in_msg.start_tx = false;
        tasks_in_msg.stop_tx = false;
        cts_in_msg = CTS_ACTIVATED;
        tx_events_msg.done = false;
        rx_events_msg.error_src = 0;
        rx_events_msg.ready = false;
        rx_events_msg.timeout = false;
        events_out_msg.cts = false;
        events_out_msg.ncts = false;
        events_out_msg.rxd_ready = false;
        events_out_msg.txd_ready = false;
        events_out_msg.error     = false;
        events_out_msg.rx_timeout = false;
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
        //bus_out_msg.valid = bus_rd || bus_wr;
        bus_out_msg.valid = bus_in_valid;

        // Task suspend is not included in PS for nRF53 UART
        //tasks_internal.suspend  = is_task_bus(bus_in_msg.addr, bus_in_msg.data, ADDR_tasks_SUSPEND);
        // BUS WRITE
        tasks.start_rx = (bus_wr && (bus_in_msg.addr == ADDR_TASKS_START_RX)) ? TASK_MASK(bus_in_msg.data) : false;
        tasks.stop_rx  = (bus_wr && (bus_in_msg.addr == ADDR_TASKS_STOP_RX))  ? TASK_MASK(bus_in_msg.data) : false;
        tasks.start_tx = (bus_wr && (bus_in_msg.addr == ADDR_TASKS_START_TX)) ? TASK_MASK(bus_in_msg.data) : false;
        tasks.stop_tx  = (bus_wr && (bus_in_msg.addr == ADDR_TASKS_STOP_TX))  ? TASK_MASK(bus_in_msg.data) : false;
        //error_src      = (bus_wr && (bus_in_msg.addr == ADDR_ERROR_SRC))      ? ERROR_MASK(~bus_in_msg.data & error_src) : error_src;
        //enable         = (bus_wr && (bus_in_msg.addr == ADDR_ENABLE))         ? ENABLE_MASK(bus_in_msg.data)             : enable;
        //frame_config   = (bus_wr && (bus_in_msg.addr == ADDR_CONFIG))         ? CONFIG_MASK(bus_in_msg.data)             :frame_config;


        // BUS READ
        bus_out_msg.data = (bus_rd && bus_in_msg.addr == ADDR_ERROR_SRC) ? error_src    : bus_out_msg.data;
        bus_out_msg.data = (bus_rd && bus_in_msg.addr == ADDR_ENABLE)    ? enable       : bus_out_msg.data;
        bus_out_msg.data = (bus_rd && bus_in_msg.addr == ADDR_CONFIG)    ? frame_config : bus_out_msg.data;

        // EVENTS
        events_out_msg.txd_ready   = (ENABLE(enable) && tx_events_valid) ? tx_events_msg.done             : false;
        events_out_msg.rxd_ready   = (ENABLE(enable) && rx_events_valid) ? rx_events_msg.ready            : false;
        events_out_msg.rx_timeout  = (ENABLE(enable) && rx_events_valid) ? rx_events_msg.timeout          : false;
        events_out_msg.error       = (ENABLE(enable) && rx_events_valid) ? (rx_events_msg.error_src != 0) : false;

        // TODO: Move cts to another file? Will be located in another clock/power domain

        events_out_msg.cts  = (ENABLE(enable) && HWFC(frame_config) && cts_in_valid) ? cts_in_msg == CTS_ACTIVATED   : false;
        events_out_msg.ncts = (ENABLE(enable) && HWFC(frame_config) && cts_in_valid) ? cts_in_msg == CTS_DEACTIVATED : false;


        cts_internal = (!HWFC(frame_config) || events_out_msg.cts)  ? CTS_ACTIVATED   : cts_internal;
        cts_internal = ( HWFC(frame_config) && events_out_msg.ncts) ? CTS_DEACTIVATED : cts_internal;

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
        tx_active_out_msg = ENABLE(enable) && (tasks.start_tx || (tx_active_out_msg && !(tasks.stop_tx)));

        rx_active_out_msg = ENABLE(enable) && (tasks.start_rx || (rx_active_out_msg && !(tasks.stop_rx)));


#ifdef SIM
        //if (tasks.start_rx) debug_print(CONTROL, "Tasks_start_rx");
        //if (tasks.stop_rx) debug_print(CONTROL, "Tasks_stop_rx");
        //if (rx_active_out_msg) debug_print(CONTROL, "RX_ACTIVE_OUT_MSG high");
        if ((tx_active_out_msg != tx_active_prev) && tx_active_out_msg) debug_print(CONTROL, "TX status change! TX now ON");
        if ((tx_active_out_msg != tx_active_prev) && !tx_active_out_msg) debug_print(CONTROL, "TX status change! TX now OFF");
        if ((rx_active_out_msg != rx_active_prev) && rx_active_out_msg) debug_print(CONTROL, "RX status change! RX now ON");
        if ((rx_active_out_msg != rx_active_prev) && !rx_active_out_msg) debug_print(CONTROL, "RX status change! RX now OFF");
        tx_active_prev = tx_active_out_msg;
        rx_active_prev = rx_active_out_msg;
#endif

        //ctrl_to_hwfc_msg = rx_active_out_msg && (HWFC_MASK(config) != 0);

        // Update ERROR_SRC register in case of errors.
        // New errors have priority over clearance
        

#ifdef SIM
        //if (config_msg.parity) debug_print(CONTROL, "Parity true!");
#endif
        // Consider moving back here
        if (HWFC(frame_config) && rx_active_out_msg && (rts_internal == RTS_DEACTIVATED))
        {
            rts_internal = RTS_ACTIVATED;
            rts_out->master_write(rts_internal);
        }
        else if (HWFC(frame_config) && !rx_active_out_msg && (rts_internal == RTS_ACTIVATED))
        {
            rts_internal = RTS_DEACTIVATED;
            rts_out->master_write(rts_internal);
        }

        error_src_tmp  = (bus_wr && (bus_in_msg.addr == ADDR_ERROR_SRC)) ? ERROR_MASK(~bus_in_msg.data & error_src) : error_src;
        error_src      = (ENABLE(enable) && rx_events_valid)             ? (error_src_tmp | rx_events_msg.error_src): error_src_tmp;
        enable         = (bus_wr && (bus_in_msg.addr == ADDR_ENABLE))    ? ENABLE_MASK(bus_in_msg.data)             : enable;
        frame_config   = (bus_wr && (bus_in_msg.addr == ADDR_CONFIG))    ? CONFIG_MASK(bus_in_msg.data)             :frame_config;

#ifdef SIM
        if (bus_wr && (bus_in_msg.addr == ADDR_ENABLE)) debug_print(CONTROL, "Write to ENABLE register");
        if (bus_wr) std::cout << "Enable register is " << enable << std::endl;
        if (bus_rd && (bus_in_msg.addr == ADDR_ENABLE)) debug_print(CONTROL, "Read from ENABLE register");
        if (bus_rd) std::cout << "Enable register is " << enable << ", data_out is " << bus_out_msg.data << std::endl;
#endif

        config_msg.parity        = PARITY(frame_config);
        config_msg.two_stop_bits = STOP(frame_config);
        config_msg.odd_parity    = ODD_PARITY(frame_config);

        if (cts_in_valid || rx_events_valid || tx_events_valid)
        {
            events_out->master_write(events_out_msg);
        }
        tx_active_out->set(tx_active_out_msg);
        rx_active_out->set(rx_active_out_msg);
        //hwfc_control_out->slave_write(ctrl_to_hwfc_msg);
        bus_out->slave_write(bus_out_msg);
        tx_config_out->set(config_msg);
#ifdef SIM
        rx_config_out->set(config_msg);
#endif

    }
}