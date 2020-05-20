#include "Interfaces.h"
#include "FIFO.h"
#include "systemc.h"

SC_MODULE(Consumer){
  sc_port<FIFO_in_if<int>> inp;

  int value = 0;
  float random;
  float limit = 0.75;
  int value_old = 0;

  void check_inp(){

      while(true) {
          //Consumes values from the Output of the FIFO
          random = ((float) rand()) / (float) RAND_MAX;
          while (random < limit) {
              insert_state();
              random = ((float) rand()) / (float) RAND_MAX;
          }
          inp->read(value);
          sc_assert(value == value_old + 1);
          value_old = value;
          std::cout << "At " << sc_time_stamp() << " Consumer received: " << value << endl;
          insert_state();
      }
  }

  SC_CTOR(Consumer){
    SC_THREAD(check_inp);
  }
};
