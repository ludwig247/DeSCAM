//
// Created by wezel on 2/18/20.
//

#ifndef SCAM_FIFO_H
#define SCAM_FIFO_H

#include "systemc.h"
#include "FIFO_ifs.h"


void inline wait_event(sc_event event){
    wait(event);
};

void inline notify_event(sc_event event){
    event.notify();
};



const int size = 16;
template<typename T>
class Regfile : public sc_prim_channel,
                virtual public FIFO_in_if<T>,          //
                     virtual public FIFO_out_if<T> {        //
public:
    Regfile(const char *name);

    // Consumer reads Value from FIFO (blocking)
    bool read(T &out);
    //Producer writes Value to FIFO (blocking)
    bool write(const T &val);

private:

    //T  * buffer; //INFO: needs to be static at compile time somehow ... can't deal with a pointer in SystemC-PPA
    int buffer[size];
    unsigned int fifo_size;
    enum states {
        EMPTY, FILLED, FULL
    };
    states state;
    unsigned int head;
    unsigned int tail;
    sc_event reader_notify, writer_notify;
};

#include "FIFO.hpp"

#endif //SCAM_FIFO_H


