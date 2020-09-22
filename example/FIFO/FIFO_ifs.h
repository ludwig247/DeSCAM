//
// Created by wezel on 2/18/20.
//

#ifndef SCAM_FIFO_IFS_H
#define SCAM_FIFO_IFS_H

template<typename T>
class FIFO_in_if : virtual public sc_interface
{
public:
    virtual bool read(T & out) = 0;
};


template<typename T>
class FIFO_out_if : virtual public sc_interface
{
public:
    virtual bool write(const T & val) = 0; //regular blocking write
};
#endif //SCAM_FIFO_IFS_H
