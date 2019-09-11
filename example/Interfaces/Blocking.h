#ifndef Blocking_H
#define Blocking_H

#include "systemc.h"
#include "blocking_ifs.h"

//#define VERBOSE

template<typename T>
class Blocking : public sc_prim_channel,
                   virtual public blocking_in_if<T>,
                   virtual public blocking_out_if<T> {
public:
    Blocking(const char *name);

    virtual void read(T & out);
    virtual bool nb_read(T & out);

    virtual void write(const T &val);
    virtual bool nb_write(const T &val);

    virtual void register_port(sc_port_base &port, const char *if_typename);

private:

    T shared_value;

    bool writer_ready, reader_ready;
    sc_event reader_notify, writer_notify;
    sc_port_base *reader, *writer;
};

#include "Blocking.hpp"

#endif
