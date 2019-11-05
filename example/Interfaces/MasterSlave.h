//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 2/9/19.
//

#ifndef INTERFACES_MASTERSLAVE_H
#define INTERFACES_MASTERSLAVE_H

#include "systemc.h"
#include "tlm.h"
#include "tlm_utils/simple_target_socket.h"
#include "tlm_utils/simple_initiator_socket.h"
#include "masterSlave_ifs.h"

template<typename T>
class MasterSlave : public sc_prim_channel,
                    virtual public master_in_if<T>,
                    virtual public master_out_if<T>,
                    virtual  public slave_in_if<T>,
                    virtual public slave_out_if<T> {
public:
    MasterSlave(const char *name);

    void master_read(T &out);

    void master_write(const T &val);

//    bool slave_read(T &out);
    void slave_read(T & out);
    void slave_read(T & out, bool & success);

    void slave_write(const T &val);

//    bool peek();
//
//    bool poke();

    void register_port(sc_port_base &port, const char *if_typename);

private:
    T *shared_data;
    bool available_data, data_read;
    bool reader_ready, writer_ready;

    sc_event reader_notify, writer_notify;
    sc_port_base *reader, *writer;
    std::string reader_if, writer_if;
};

#include "MasterSlave.hpp"

#endif //INTERFACES_MASTERSLAVE_H
