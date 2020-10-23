//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 10/24/18.
//
/**
 * \class: UVM monitor
 * - The monitor is a passive element that ‘only’ captures the DUT signals.
 *      Remark: monitor is passive but if the "fromMemory" command is a write command resulting from a store instruction then the subscriber needs to handle it.
 * - It extracts signal information from the interface and translates this information to abstract transactions.
 * - It will distribute this transaction to all connected elements for e.g. coverage collection and checking. //FIXME: does this mean I can connect it to different subscribers (one for read instruction request and one for load-store data) ?
 * - Connection between the monitor and the DUT is established by using a dedicated channel, which is made available via the configuration mechanism.
 *
 */

#ifndef UVMSYSTEMC_VIP_MONITOR_H
#define UVMSYSTEMC_VIP_MONITOR_H

#include <uvm>
#include "vip_trans.h"
#include "vip_if.h"
using namespace uvm;

class vip_monitor : public uvm_monitor {
public:
    uvm_analysis_port<vip_trans_toMemory> item_collected_port; /// Analysis port used to pass collected data to attached components
    vip_if_toMemory *vif;

    vip_monitor(uvm_component_name name) : uvm_monitor(name) {}

    UVM_COMPONENT_UTILS(vip_monitor)

    void build_phase(uvm_phase &phase) {
        uvm_monitor::build_phase(phase);

        /// Get interface object using the configuration mechanism
        if (!uvm_config_db<vip_if_toMemory *>::get(this, "*", "vif", vif))
            UVM_FATAL(this->get_name(), "Virtual interface not defined! Simulation aborted!");
    }

    void run_phase(uvm_phase &phase) {
        vip_trans_toMemory t;
        /// Remark: read initial port values and discard it at the moment
        vif->toMemory_Port.read(t.toMemory);
        while (true) // monitor forever
        {
//            wait(vif->sig_a.default_event()); //Remark: This can be used if we have access to "writer_notify" event of the Blocking channel
            vif->toMemory_Port.read(t.toMemory);
//            std::cout << name() << " received request addr: 0x" << hex << t.toMemory.addrIn << std::endl;
            item_collected_port.write(t);
        }
    }

//    void extract_phase( uvm_phase& phase){
//        uvm_report_info( "monitor", "************** extract_phase **************", uvm::UVM_NONE );
//    }

}; // class vip_monitor

#endif //UVMSYSTEMC_VIP_MONITOR_H
