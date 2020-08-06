//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 10/24/18.
//

#ifndef UVMSYSTEMC_SUBSCRIBER_TOMEMORY_H
#define UVMSYSTEMC_SUBSCRIBER_TOMEMORY_H

#include <uvm>
#include "vip_trans.h"
using namespace uvm;

class subscriber_toMemory: public uvm_subscriber<vip_trans_toMemory> {
public:
    subscriber_toMemory(uvm_component_name name);

    UVM_COMPONENT_UTILS(subscriber_toMemory)

    virtual void write(const vip_trans_toMemory& t);
};


#endif //UVMSYSTEMC_SUBSCRIBER_TOMEMORY_H
