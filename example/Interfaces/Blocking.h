//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 2/9/19.
//

#ifndef INTERFACES_BLOCKING_H
#define INTERFACES_BLOCKING_H

#include "systemc.h"
#include "blocking_ifs.h"
#include "ImportantState.h"


template<typename T>
class Blocking : public sc_prim_channel,
                 virtual public blocking_in_if<T>,
                 virtual public blocking_out_if<T> {
public:
    Blocking(const char *name);

    void read(T &out);
    void try_read(T & out);
    void try_read(T & out, bool & success);

    bool peek();
    bool poke();

    void write(const T &val);
    void try_write(const T &val);
    void try_write(const T &val, bool & success);

    void read(T &out, std::string stateName) override;

    void try_read(T &out, bool &success, std::string stateName) override;

    void try_write(const T &val, bool &success, std::string stateName) override;

    void write(const T &val, std::string stateName) override;

    void register_port(sc_port_base &port, const char *if_typename);

private:
    const T *shared_data;
    bool available_data;
    bool writer_ready, reader_ready;
    sc_event reader_notify, writer_notify;
    sc_port_base *reader, *writer;
};

#include "Blocking.hpp"

#endif //INTERFACES_BLOCKING_H
