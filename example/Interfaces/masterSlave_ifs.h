#ifndef ALWAYSREADY_IFS
#define ALWAYSREADY_IFS

#include "systemc.h"

/***
Module A: alwaysReady_out<int> x; or one cycle ...
Message is send with x.write(msg) and the reader is always ready to receive a new message and thus the port is never blocked.
Message is send at the end of operation with raised notify for one cycle and thus creates no additional abstract state.
Exception: two consecutive x->write() without a blocking communication in between. A abstract control state is necessary because each message needs to be send


        Module B: alwaysReady_out<int> y; //corresponding one cycle input:
Message is received with: y->nb_read(msg) and use of this port triggers:
-all properties to be only one cycle long
-forbids blocking->read blocking->write, because during the wait operations a message might be lost
-allows one nb_read/nb_write between to y->nb_read(msg) those will be executed concurrently with the read and thus don't need an abstract state
- no notify is raised for the reader, because the message is read in every cycle anyways
*/


template<typename T>
class master_out_if : virtual public sc_interface
{
public:
    virtual void write(const T & val) = 0;
};

template<typename T>
class master_in_if : virtual public sc_interface
{
public:
    virtual void read(T & out) = 0;
};

template<typename T>
class slave_in_if : virtual public sc_interface
{
public:
    virtual bool nb_read(T & out) = 0;
};

template<typename T>
class slave_out_if : virtual public sc_interface
{
public:
    virtual void nb_write(const T &val) = 0;
//    virtual bool nb_write(const T &val) = 0;
//    virtual bool write(const T &val) = 0;
};


#endif
