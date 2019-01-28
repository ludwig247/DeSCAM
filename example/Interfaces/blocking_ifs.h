#ifndef blocking_IFS
#define blocking_IFS

#include "systemc.h"

template<typename T> 
class blocking_in_if : virtual public sc_interface 
{
   public:
      virtual void read(T & out) = 0;
      virtual bool nb_read(T & out) = 0;
};


template<typename T> 
class blocking_out_if : virtual public sc_interface 
{
   public:
      virtual void write(const T & val) = 0;
      virtual bool nb_write(const T & val) = 0;
}; 

#endif
