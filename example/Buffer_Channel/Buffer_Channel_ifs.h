//
// Created by wezel on 9/17/20.
//

#ifndef DESCAM_BUFFER_CHANNEL_IFS_H
#define DESCAM_BUFFER_CHANNEL_IFS_H

template<typename T>
class Buffer_Channel_in_if : virtual public sc_interface
{
public:
    virtual void read(T & out) = 0;
};


template<typename T>
class Buffer_Channel_out_if : virtual public sc_interface
{
public:
    virtual void write0(const T & val) = 0;
    virtual void write1(const T & val) = 0;
    virtual void write2(const T & val) = 0;
};

#endif //DESCAM_BUFFER_CHANNEL_IFS_H
