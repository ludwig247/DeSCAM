#include "../Interfaces_new/Interfaces.h"

#include "systemc.h"

SC_MODULE(Consumer){
  blocking_in<int> inp;

  int value = 0;
  bool start = true;

  void check_inp(){

      while(true) {
          if(start){
              start = false;
              wait(3.001, SC_NS);
          }
          //Read Output of FIFO
          inp->read(value);
          std::cout << "At " << sc_time_stamp() << " Consumer received: " << value << endl;
          wait(1,SC_NS);
      }
  }

  SC_CTOR(Consumer){
    SC_THREAD(check_inp);
  }
};
