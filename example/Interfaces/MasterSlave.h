#ifndef ALWAYSREADY_H
#define ALWAYSREADY_H

#include "systemc.h"
#include "masterSlave_ifs.h"

//#define VERBOSE

template<typename T>
class MasterSlave : public sc_prim_channel,
                   virtual public master_in_if<T>,
                   virtual public master_out_if<T>,
                    virtual  public slave_in_if<T>,
                    virtual public slave_out_if<T> {
public:
    MasterSlave(const char *name);

    virtual void read(T & out);
    virtual bool nb_read(T & out);

//    virtual bool nb_write(const T &val);
    virtual void write(const T &val);
    virtual void nb_write(const T &val);

    virtual void register_port(sc_port_base &port, const char *if_typename);

private:

    T shared_value;

    bool writer_ready, reader_ready;
    sc_event reader_notify, writer_notify;
    sc_port_base *reader, *writer;
    std::string reader_if, writer_if;

};

#include "MasterSlave.hpp"

#endif
