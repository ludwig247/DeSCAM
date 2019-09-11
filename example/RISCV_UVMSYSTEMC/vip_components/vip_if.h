//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 10/24/18.
//

#ifndef UVMSYSTEMC_VIP_IF_H
#define UVMSYSTEMC_VIP_IF_H

#include <systemc>
#include "Interfaces.h"
#include "Memory_Interfaces.h"

class vip_if_toMemory
{
public:
    Blocking<CUtoME_IF> toMemory_Port;
    vip_if_toMemory() : toMemory_Port("toMemory_Port") {}
};

class vip_if_fromMemory
{
public:
    Blocking<MEtoCP_IF> fromMemory_Port;
    vip_if_fromMemory() : fromMemory_Port("fromMemory_Port") {}
};
#endif //UVMSYSTEMC_VIP_IF_H
