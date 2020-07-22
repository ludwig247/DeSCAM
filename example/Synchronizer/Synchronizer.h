//
// Created by wezel on 7/13/20.
//

#ifndef DESCAM_SYNCHRONIZER_H
#define DESCAM_SYNCHRONIZER_H

#include "systemc.h"
#include "Synchronizer_ifs.h"

template<typename T>
class Synchronizer : public sc_prim_channel,
             virtual public Synchronizer_in_if<T>,          //
             virtual public Synchronizer_out_if<T> {        //
public:
    Synchronizer(const char *name);

    // Consumer reads Value from FIFO (blocking)
    void read(std::array<T,NUMBER_OF_SENDERS> * out);
    //Producer writes Value to FIFO (blocking)
    void write(const T &val, int id);

private:
    int cnt;
    std::array<bool,NUMBER_OF_SENDERS> flags;
    std::array<T,NUMBER_OF_SENDERS> buffer;
    sc_event reader_notify, writer_notify;
};

#include "Synchronizer.hpp"

#endif //DESCAM_SYNCHRONIZER_H
