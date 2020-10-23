//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 10/23/18.
//
/**
 \class: * UVM virtual sequencer
    - A virtual sequencer contains references to its subsequencers such as UVC sequencers or other virtual sequencers.
    - Virtual sequencers process virtual sequences which encapsulate sequences for multiple verification components.
    - Virtual sequencers do not execute transactions on themselves but ‘offload’ this to its subsequencers
 */
#ifndef UVMSYSTEMC_VIRTUAL_SEQUENCER_H
#define UVMSYSTEMC_VIRTUAL_SEQUENCER_H

#include "vip_sequencer.h"
#include "vip_trans.h"
using namespace uvm;

class virt_sequencer : public uvm_sequencer<> /// As the virtual sequencer does not process transactions itself, we do not specify a template parameter
{
public:
    vip_sequencer<vip_trans_fromMemory>* vip_seqr;
    UVM_COMPONENT_UTILS(virt_sequencer)
    virt_sequencer( uvm_component_name name )
            : uvm_sequencer<>( name ) {
        std::cout << sc_core::sc_time_stamp() << ": constructor " << name << std::endl;
    }
}; // class virt_sequencer
#endif //UVMSYSTEMC_VIRTUAL_SEQUENCER_H
