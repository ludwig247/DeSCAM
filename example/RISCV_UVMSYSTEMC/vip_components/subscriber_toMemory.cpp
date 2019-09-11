//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 10/24/18.
//

#include "subscriber_toMemory.h"
#include "scoreboard.h"

subscriber_toMemory::subscriber_toMemory(uvm_component_name name): uvm_subscriber(name) {}

/// Implementation of the write method for the export in the monitor (in our case it's the driver in the active agent)
void subscriber_toMemory::write(const vip_trans_toMemory& t) {

    sc_object* obj = get_parent();
    scoreboard* sb;
    sb = dynamic_cast<scoreboard*>(obj);
    sb->write_listener_toMemory(t); /// Transactions (toMemory) are passed to the parenting scoreboard
}