#include "Interfaces.h"
#include "Synchronizer.h"
#include "systemc.h"

SC_MODULE(Consumer){
  sc_port<Synchronizer_in_if<int>> inp;

  int value[3];
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
          std::cout << "At " << sc_time_stamp() << " Consumer tries to read" << endl;
          inp->read(value);
          sc_assert((2*value[0] == value[1]) && (3*value[0] == value[2]));
          std::cout << "At " << sc_time_stamp() << " Consumer received: " << value[0] << ", " << value[1] << ", " << value[2] << endl;
//          insert_state();
      }
  }

  SC_CTOR(Consumer){
    SC_THREAD(check_inp);
  }
};
