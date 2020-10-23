//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 13.10.18.
//

#ifndef PROJECT_MIP_H
#define PROJECT_MIP_H

#define Fill_Right(amt) ((1 << amt) - 1)
#define Fill_Left(amt) (static_cast<unsigned int>(0xFFFFFFFF) << (amt+1))

#include "systemc.h"
#include "Interfaces.h"

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
 * \remark: reading from interrupt sources happens with non-blocking communication to insure that mip controller scans all
 * sources without getting stuck at any of them because of some mal functioning at that interrupt source.
 * Also, writing to the core happens with a non-blocking communication to insure that mip is scanning the interrupt sources
 * non stop and feeding the core with the very latest read of their statuses.
 */
void Mip::run(){
    while(true) {
        mip_isa_Port->nb_write(mip);

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
        return mip & ( Fill_Left(position) | Fill_Right(position) );
}

#endif  // PROJECT_MIP_H