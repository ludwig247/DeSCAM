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
    explicit MasterSlave(const char *name);
    MasterSlave() = delete;

    void master_read(T &out,std::string stateName) override;
    void master_read(T &out) override;

    void master_write(const T &val,std::string stateName) override;
    void master_write(const T &val) override ;

    void slave_read(T & out) override;
    void slave_read(T & out, bool & success) override;

    void slave_write(const T &val) override ;

    void register_port(sc_port_base &port, const char *if_typename);

private:
    const T *shared_data;
    bool available_data;

    sc_event reader_notify, writer_notify;
    sc_port_base *reader, *writer;
    std::string reader_if, writer_if;
};

#include "MasterSlave.hpp"

#endif //INTERFACES_MASTERSLAVE_H
