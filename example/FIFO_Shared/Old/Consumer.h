#include "Interfaces.h"
#include "FIFO_Channel.h"
#include "systemc.h"

SC_MODULE(Consumer){
  sc_port<FIFO_in_if<int>> inp;

  int value = 0;

  void check_inp(){

      while(true) {
          //Consumes values from the Output of the FIFO
          inp->read(value);
          std::cout << "At " << sc_time_stamp() << " Consumer received: " << value << endl;
          wait(2*WAIT_TIME,SC_NS);
      }
  }

  SC_CTOR(Consumer){
    SC_THREAD(check_inp);
  }
};
