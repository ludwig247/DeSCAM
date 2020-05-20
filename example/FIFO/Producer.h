#include "Interfaces.h"
#include "FIFO.h"
#include "systemc.h"

SC_MODULE(Producer){
    sc_port<FIFO_out_if<int>> out;

  int cnt = 1;
  float random;
  float limit = 0.5;

  void drive_out(){
      while(true) {
          random = ((float) rand()) / (float) RAND_MAX;
          while (random < limit) {
              insert_state();
              random = ((float) rand()) / (float) RAND_MAX;
          }
          if (cnt > 10) break;
          //Produce Values and write them to the Input of the FIFO
          out->write(cnt++);
          std::cout << "At " << sc_time_stamp() << " Producer sent: " << cnt-1 << endl;
          insert_state();
      }
  }

  SC_CTOR(Producer){
    SC_THREAD(drive_out);
  }
};
