//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 10/24/18.
//

#ifndef UVMSYSTEMC_SUBSCRIBER_FROMMEMORY_H
#define UVMSYSTEMC_SUBSCRIBER_FROMMEMORY_H

#include <uvm>
#include "vip_trans.h"
using namespace uvm;

class subscriber_fromMemory: public uvm_subscriber<vip_trans_fromMemory> {
public:
    subscriber_fromMemory(uvm_component_name name);

    UVM_COMPONENT_UTILS(subscriber_fromMemory)

    virtual void write(const vip_trans_fromMemory &t);
};


#endif //UVMSYSTEMC_SUBSCRIBER_FROMMEMORY_H
