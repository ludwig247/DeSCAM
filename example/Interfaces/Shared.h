#ifndef SHARED_H
#define SHARED_H

#include "systemc.h"
#include "shared_ifs.h"


template<typename T>
class Shared : public sc_prim_channel,
                   virtual public shared_in_if<T>,
                   virtual public shared_out_if<T> {
public:
    Shared(const char *name);

    virtual void get(T& out);

    virtual void set(const T &val);

    virtual void register_port(sc_port_base &port, const char *if_typename);

private:
    sc_port_base *reader, *writer;
    T shared_value;
};

#include "Shared.hpp"

#endif
