//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 2/9/19.
//

#ifndef INTERFACES_SHARED_IFS
#define INTERFACES_SHARED_IFS

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

#endif //INTERFACES_SHARED_IFS
