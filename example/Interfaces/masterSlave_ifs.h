//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 2/9/19.
//

#ifndef INTERFACES_MASTERSLAVE_IFS_H
#define INTERFACES_MASTERSLAVE_IFS_H



template<typename T>class master_out_if : virtual public sc_interface
{
public:
    virtual void master_write(const T & val,std::string stateName) = 0;
    virtual void master_write(const T & val) = 0;
};

template<typename T>
class master_in_if : virtual public sc_interface
{
public:
    virtual void master_read(T & out,std::string stateName) = 0;
    virtual void master_read(T & out) = 0;
};

template<typename T>
class slave_in_if : virtual public sc_interface
{
public:
    virtual void slave_read(T & out) = 0;
    virtual void slave_read(T & out, bool & success) = 0;

};

template<typename T>
class slave_out_if : virtual public sc_interface
{
public:
    virtual void slave_write(const T &val) = 0;
};

#endif //INTERFACES_MASTERSLAVE_IFS_H
