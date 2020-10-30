//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 13.10.18.
//

#ifndef PROJECT_MIP_H
#define PROJECT_MIP_H

#include "systemc.h"
#include "Interfaces.h"
#include "../Defines.h"

class Mip : public sc_module {
public:
    //Constructor
    SC_HAS_PROCESS(Mip);

    Mip(sc_module_name name) :
            mip_isa_Port("mip_isa_Port"),
            MSIP_port("MSIP_port"),
            MTIP_port("MTIP_port"),
            MEIP_port("MEIP_port"),
#ifdef CoreTempSensor_ON
            ML12I_port("ML12I_port"),
#endif
            mip(0),
            temp(false) {
        SC_THREAD(run);
    }

    slave_out<unsigned int> mip_isa_Port;

    master_in<bool> MSIP_port;
    master_in<bool> MTIP_port;
    master_in<bool> MEIP_port;
#ifdef CoreTempSensor_ON
    master_in<bool> ML12I_port;
#endif
    unsigned int mip;
    bool temp;

    void run();
    unsigned int manageBit(unsigned int mip, bool interruptStatus, unsigned int position) const;
};

/**
 * \remark: reading from interrupt sources happens without blocking to make sure the mip controller scans all
 * sources without getting stuck at any of them because of some mal functioning at that interrupt source.
 * On the other hand, writing to the core happens with a blocking method to insure being in sync with every
 * instruction.
 */
void Mip::run(){
    while(true) {
        mip_isa_Port->nb_write(mip);

        /// interrupt source should always present a value, so no need to reset temp to false before each read
        MSIP_port->read(temp);
        mip = manageBit(mip, temp, 3);
        MTIP_port->read(temp);
        mip = manageBit(mip, temp, 7);
        MEIP_port->read(temp);
        mip = manageBit(mip, temp, 11);
#ifdef CoreTempSensor_ON
        ML12I_port->read(temp);
        mip = manageBit(mip, temp, 12);
#endif
    }
}

unsigned int Mip::manageBit(unsigned int mip, bool interruptStatus, unsigned int position) const {
    if(interruptStatus)
        return mip | (1 << position);
    else
        return mip & ( (-1 << (position+1) ) | Fill(position) );
}

#endif  // PROJECT_MIP_H