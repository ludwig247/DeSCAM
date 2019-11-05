//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 10/24/18.
//

/**
 * \class: UVM sequencer
 * - The sequencer controls and delivers transaction data items upon request of the driver.
 * - This allows to react to the current state of the DUT for every data item generated.
 * - The sequencer serves as an arbiter for controlling transactions from multiple stimulus generators.
 *  Remark: The last to statements give the assumption that it's possible to feed items from different sequences to the DUT.
 *          (one sequence gives instructions, one gives data responding to a previous "load" instructions).
 */

#ifndef UVMSYSTEMC_VIP_SEQUENCER_H
#define UVMSYSTEMC_VIP_SEQUENCER_H

#include <uvm>
using namespace uvm;

template <class REQ>
class vip_sequencer : public uvm_sequencer<REQ>
{
public:
    vip_sequencer( uvm_component_name name )
            : uvm_sequencer<REQ>( name ) {}

    UVM_COMPONENT_PARAM_UTILS(vip_sequencer<REQ>)

}; // class vip_sequencer

#endif //UVMSYSTEMC_VIP_SEQUENCER_H
