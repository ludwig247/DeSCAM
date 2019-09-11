#ifndef SHARED_IFS
#define SHARED_IFS

#include "systemc.h"

template<typename T> 
class shared_in_if : virtual public sc_interface
{
   public:
      virtual  void get(T & out) = 0;
};

template<typename T> 
class shared_out_if : virtual public sc_interface
{
   public:
      virtual void set(const T & val) = 0;
}; 

#endif
