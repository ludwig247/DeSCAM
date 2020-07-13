//
// Created by wezel on 7/13/20.
//

#ifndef DESCAM_SYNCHRONIZER_IFS_H
#define DESCAM_SYNCHRONIZER_IFS_H

template<typename T>
class Synchronizer_in_if : virtual public sc_interface
{
public:
    virtual void read(T & out) = 0;
};


template<typename T>
class Synchronizer_out_if : virtual public sc_interface
{
public:
    virtual void write(const T & val, int id) = 0; //regular blocking write
};

#endif //DESCAM_SYNCHRONIZER_IFS_H
