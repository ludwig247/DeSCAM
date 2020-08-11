//
// Created by wezel on 8/10/20.
//

#ifndef DESCAM_AHB_BUS_CHANNEL_H
#define DESCAM_AHB_BUS_CHANNEL_H

#include "systemc.h"
#include "types.h"
#include "AHB_Bus_Channel_ifs.h"


class AHB_Bus_Channel : public sc_prim_channel,
             virtual public AHB_Bus_Channel_Slave_in_if,
             virtual public AHB_Bus_Channel_Master_in_if,
             virtual public AHB_Bus_Channel_Slave_out_if,
             virtual public AHB_Bus_Channel_Master_out_if {
public:
    AHB_Bus_Channel(const char *name);

    void read_slave(bus_req_t &out, int id);
    void read_master(bus_resp_t &out, int id);
    void write_slave(const bus_resp_t &val, int id);
    void write_master(const bus_req_t &val, int id);

private:
    enum states {
        MASTER_REQ, SLAVE_REQ, SLAVE_RESP, MASTER_RESP
    };
    states state;
    int master_id;
    int slave_id;
    bus_req_t req;
    bus_resp_t resp;
    sc_event master_write_notify, master_read_notify, slave_write_notify, slave_read_notify;
};

#include "AHB_Bus_Channel.hpp"

#endif //DESCAM_AHB_BUS_CHANNEL_H
