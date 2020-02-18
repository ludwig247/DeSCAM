//
// Created by wezel on 2/18/20.
//

#ifndef SCAM_FIFO_H
#define SCAM_FIFO_H

#include "systemc.h"
#include "FIFO_ifs.h"
#include "ImportantState.h"

template<typename T>
class FIFO : public sc_prim_channel,
                     virtual public FIFO_in_if<T>,          //
                     virtual public FIFO_out_if<T> {        //
public:
    FIFO(const char *name, unsigned int size);

    // Consumer reads Value from FIFO (blocking)
    void read(T &out);
    //Producer writes Value to FIFO (blocking)
    void write(const T &val);

private:
    T *buffer;
    unsigned int fifo_size;
    enum states {
        EMPTY, FILLED, FULL
    };
    states state;
    int head;
    int tail;
    sc_event reader_notify, writer_notify;
};

#include "FIFO.hpp"

#endif //SCAM_FIFO_H


