//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 10/24/18.
//
/**
 * \class: UVM driver
 * - The driver is responsible to create the physical signals to drive the DUT.
 * - For this, the driver repeatedly requests transactions, encapsulated in a sequence, via the sequencer, and translates these to one or more physical signal(s).
 *      Remark: this depends on the structure of the sequence transaction (item). if we pack signals together or not.
 * - Connection between the driver and the DUT is established by using a dedicated channel, which is made available via the configuration mechanism.
 */

#ifndef UVMSYSTEMC_VIP_DRIVER_H
#define UVMSYSTEMC_VIP_DRIVER_H


#include <uvm>
#include "vip_if.h"

template <class REQ>
class vip_driver : public uvm::uvm_driver<REQ> {
public:
    uvm::uvm_analysis_port<REQ> item_collected_port;
    vip_if_fromMemory *vif; /// Placeholder needed to store the handle to the interface object

    vip_driver(uvm::uvm_component_name name) : uvm::uvm_driver<REQ>(name){}

    UVM_COMPONENT_PARAM_UTILS(vip_driver<REQ>); /// Registration of the template class

    void build_phase(uvm::uvm_phase &phase) {
        uvm::uvm_driver<REQ>::build_phase(phase);

        /// Get interface object using the configuration mechanism
        if (!uvm::uvm_config_db<vip_if_fromMemory *>::get(this, "*", "vif", vif))
            UVM_FATAL(this->get_name(), "Virtual interface not defined! Simulation aborted!");
    }

    void run_phase(uvm::uvm_phase &phase) {
        REQ req, rsp;
        while (true) // forever loop
        {
            this->seq_item_port->get_next_item(req); /// Process transactions via the sequencer interface
            drive_transfer(req);
            item_collected_port.write(req);
            rsp.set_id_info(req); // Remark: I guess this will help the sequencer to decide what next sequence item should be (from which sequence to pull it, instruction or data)
            this->seq_item_port->item_done(); /// Process transactions via the sequencer interface
            this->seq_item_port->put_response(rsp); /// Process transactions via the sequencer interface
        }
    }

    void drive_transfer(const REQ &p) {
//        std::cout << this->name() << " sending reply " << p.fromMemory.loadedData << std::endl;
        vif->fromMemory_Port.write(p.fromMemory); /// Driver output signals are written to the interface directly
    }

//    void extract_phase( uvm::uvm_phase& phase){
//        uvm_report_info( "driver", "************** extract_phase **************", uvm::UVM_NONE );
//    }

}; // class vip_driver

#endif //UVMSYSTEMC_VIP_DRIVER_H
