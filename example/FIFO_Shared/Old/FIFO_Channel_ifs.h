//
// Created by wezel on 10/24/19.
//

#ifndef SCAM_FIFO_CHANNEL_IFS_H
#define SCAM_FIFO_CHANNEL_IFS_H

template<typename T>
class FIFO_in_if : virtual public sc_interface
{
public:
    virtual void read(T & out) = 0;
};


template<typename T>
class FIFO_out_if : virtual public sc_interface
{
public:
    virtual void write(const T & val) = 0; //regular blocking write
};
#endif //SCAM_FIFO_CHANNEL_IFS_H
