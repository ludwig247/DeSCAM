//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 2/9/19.
//

#ifndef INTERFACES_BLOCKING_IFS_H
#define INTERFACES_BLOCKING_IFS_H


template<typename T>
class blocking_in_if : virtual public sc_interface
{
public:
    virtual void read(T & out) = 0;
    virtual void read(T & out,std::string stateName) = 0;
    virtual void try_read(T & out) = 0;
    virtual void try_read(T & out, bool & success) = 0;
    virtual void try_read(T & out, bool & success, std::string stateName) = 0;
    virtual bool peek() = 0;
};


template<typename T>
class blocking_out_if : virtual public sc_interface
{
public:
    virtual bool poke() = 0; //just an expression
    virtual void try_write(const T & val) = 0; //stmt
    virtual void try_write(const T & val, bool & success, std::string stateName) = 0; //stmt with reference for succ
    virtual void try_write(const T & val, bool & success) = 0; //stmt with reference for succ
    virtual void write(const T & val) = 0; //regular blocking write
    virtual void write(const T & val,std::string stateName) = 0; //regular blocking write
//    virtual void write(const T & val) = 0;
//    virtual bool poke() = 0;
};

#endif //INTERFACES_BLOCKING_IFS_H
