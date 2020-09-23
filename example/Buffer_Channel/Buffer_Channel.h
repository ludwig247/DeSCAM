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
    void write0(const T &val);
    void write1(const T &val);
    void write2(const T &val);


private:
    std::array<int,size> buffer0;
    std::array<int,size> buffer1;
    std::array<int,size> buffer2;

    enum states {
        EMPTY, FILLED, FULL
    };
    states state0;
    states state1;
    states state2;
    int head0;
    int tail0;
    int head1;
    int tail1;
    int head2;
    int tail2;
    int next_read;
    sc_event reader_notify0, reader_notify1, reader_notify2, writer_notify0, writer_notify1, writer_notify2;
};

#include "Buffer_Channel.hpp"

#endif //DESCAM_BUFFER_CHANNEL_H
