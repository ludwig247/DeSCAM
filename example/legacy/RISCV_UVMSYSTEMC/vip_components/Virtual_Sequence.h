//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 10/23/18.
//
/**
 * \class: UVM virtual sequence
    - A virtual sequence encapsulates one or more sequences, which are executed on the sub-sequencers in each UVC agent, which are all connected to the parent virtual
        sequencer.
        * Remark: So each sequence will be targeting a certain DUT interface (signal) (ex. a sequence for "fromMemory_port" and a sequence for "MEIP_port".
                and it's not possible to give different sequences targeting the same interface. meaning, it's not possible to separate instructions sequence from
                loaded data sequence.
    - A virtual sequence can be configured as default sequence in a test, to facilitate automatic execution on a virtual sequencer or a sequencer which belongs to a UVC
        agent.
 */
#ifndef UVMSYSTEMC_VIRTUAL_SEQUENCE_H
#define UVMSYSTEMC_VIRTUAL_SEQUENCE_H

#include <uvm>
#include "Tests/Single_Type_Tests/Single_Type_Sequences.h"
#include "vip_trans.h"
#include "Virtual_Sequencer.h"
using namespace uvm;

class virt_sequence : public uvm_sequence<> {
public:
    sequence_R <vip_trans_fromMemory> *vip_seq;

    virt_sequence(const std::string &name = "virt_sequence")
            : uvm_sequence<>(name) {
        std::cout << sc_core::sc_time_stamp() << ": constructor " << name << std::endl;
    }

    UVM_OBJECT_UTILS(virt_sequence)

    UVM_DECLARE_P_SEQUENCER(virt_sequencer) /// Declaration of the parent sequencer

    void body() {
        UVM_INFO(get_name(), "Virtual sequence starts here...", uvm::UVM_NONE);
        UVM_DO_ON(vip_seq, p_sequencer->vip_seqr) /// Macro to start sequence on a specific sequencer using its member function start
        UVM_INFO(get_name(), "Virtual sequence finished.", uvm::UVM_NONE);
    }
}; // class virt_sequence
#endif //UVMSYSTEMC_VIRTUAL_SEQUENCE_H
