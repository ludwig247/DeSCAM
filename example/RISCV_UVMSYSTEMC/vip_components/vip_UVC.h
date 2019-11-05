//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 10/24/18.
//
/**
 * \class: UVM verification component (UVC)
    - A reusable verification component (UVC) is a (sub-) environment which consists of one or more agents.
    - The verification component or agents may set or get configuration parameters.
    - An independent sequence, which contains the actual transaction data, is processed by the driver via a sequencer.
    - Each verification component is connected to the DUT using a dedicated interface.

    Remark Might use such a method if we want to separate different signal interfaces to the dut with different sequences and sequences's items instead of using a packed
        item style.
 */
#ifndef UVMSYSTEMC_VIP_UVC_H
#define UVMSYSTEMC_VIP_UVC_H

#include <uvm>
#include "vip_agent.h"
using namespace uvm;

class vip_uvc : public uvm_env /// A UVC is treated as a sub-environment in large-system level environments
{
public:
    vip_agent *agent;

    UVM_COMPONENT_UTILS(vip_uvc);

    vip_uvc(uvm_component_name name)
            : uvm_env(name), agent(0) {}

    void build_phase(uvm_phase &phase) /// Components are instantiated in the build phase
    {
        uvm_env::build_phase(phase); /// Essential call to base class to access properties of the env
        agent = vip_agent::type_id::create("agent", this); /// Call to the factory which creates and instantiates this component dynamically
        assert(agent);
    }

}; // class vip_uvc

#endif //UVMSYSTEMC_VIP_AGENT_H