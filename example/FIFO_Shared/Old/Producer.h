#include "Interfaces.h"
#include "FIFO_Channel.h"
#include "systemc.h"

SC_MODULE(Producer){
    sc_port<FIFO_out_if<int>> out;

  int cnt = 1;

  void drive_out(){
      while(true) {
          //Produce Values and write them to the Input of the FIFO
          out->write(cnt++);
          std::cout << "At " << sc_time_stamp() << " Producer sent: " << cnt-1 << endl;
          wait(WAIT_TIME, SC_NS);
      }
  }

  SC_CTOR(Producer){
    SC_THREAD(drive_out);
  }
};
