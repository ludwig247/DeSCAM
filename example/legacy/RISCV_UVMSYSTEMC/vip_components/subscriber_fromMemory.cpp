//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 10/24/18.
//

#include "subscriber_fromMemory.h"
#include "scoreboard.h"

subscriber_fromMemory::subscriber_fromMemory(uvm_component_name name) : uvm_subscriber(name) {}

/// Implementation of the write method for the export in the monitor (in our case it's the driver in the active agent)
void subscriber_fromMemory::write(const vip_trans_fromMemory& t)
{
    sc_object* obj = get_parent();
    scoreboard* sb;
    sb = dynamic_cast<scoreboard*>(obj);
    sb->write_listener_fromMemory(t); /// Transactions (fromMemory) are passed to the parenting scoreboard
}
