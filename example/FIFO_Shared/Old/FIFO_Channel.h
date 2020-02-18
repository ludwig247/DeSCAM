//
// Created by wezel on 10/24/19.
//

#ifndef SCAM_FIFO_CHANNEL_H
#define SCAM_FIFO_CHANNEL_H

#include "systemc.h"
#include "FIFO_Channel_ifs.h"

template<typename T>
class FIFO_Channel : public sc_prim_channel,
                 virtual public FIFO_in_if<T>,          //
                 virtual public FIFO_out_if<T> {        //
public:
    FIFO_Channel(const char *name, unsigned int size);

    // Consumer reads Value from FIFO (blocking)
    void read(T &out);
    //Producer writes Value to FIFO (blocking)
    void write(const T &val);

private:
    T *buffer;
    unsigned int fifo_size;
    bool is_empty;
    bool is_full;
    unsigned int head;
    unsigned int tail;
    sc_event reader_notify, writer_notify;
};

#include "FIFO_Channel.hpp"

#endif //SCAM_FIFO_CHANNEL_H
