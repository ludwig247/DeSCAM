//
// Created by wezel on 9/17/20.
//

#ifndef DESCAM_BUFFER_CHANNEL_H
#define DESCAM_BUFFER_CHANNEL_H

#include "systemc.h"
#include "Buffer_Channel_ifs.h"
const int size = 3;
template<typename T>
class Buffer_Channel : public sc_prim_channel,
                       virtual public Buffer_Channel_in_if<T>,          //
                       virtual public Buffer_Channel_out_if<T> {        //
public:
    Buffer_Channel(const char *name);

    // Consumer reads Value from Buffer_Channel (blocking)
    void read(T &out);
    //Producer writes Value to Buffer_Channel (blocking)
    void write(const T &val);

private:
    std::array<int,size> buffer;
    enum states {
        EMPTY, FILLED, FULL
    };
    states state;
    int head;
    int tail;
    sc_event reader_notify, writer_notify;
};

#include "Buffer_Channel.hpp"

#endif //DESCAM_BUFFER_CHANNEL_H
