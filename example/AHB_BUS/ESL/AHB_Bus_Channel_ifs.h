//
// Created by wezel on 8/10/20.
//

#ifndef DESCAM_AHB_BUS_CHANNEL_IFS_H
#define DESCAM_AHB_BUS_CHANNEL_IFS_H


class AHB_Bus_Channel_Slave_in_if : virtual public sc_interface
{
public:
    virtual void read_slave(bus_req_t & out, int id) = 0;
};

class AHB_Bus_Channel_Master_in_if : virtual public sc_interface
{
public:
    virtual void read_master(bus_resp_t & out, int id) = 0;
};



class AHB_Bus_Channel_Slave_out_if : virtual public sc_interface
{
public:
    virtual void write_slave(const bus_resp_t & val, int id) = 0; //regular blocking write
};


class AHB_Bus_Channel_Master_out_if : virtual public sc_interface
{
public:
    virtual void write_master(const bus_req_t & val, int id) = 0; //regular blocking write
};

#endif //DESCAM_AHB_BUS_CHANNEL_IFS_H
