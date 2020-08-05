#include "../Interfaces/Interfaces.h"

#include "systemc.h"

SC_MODULE(Producer){
  blocking_out<int> out;

  int cnt = 1;

  void drive_out(){
      while(true) {
          //Produce Values and write them to the Input of the FIFO
          out->write(cnt++);
          std::cout << "At " << sc_time_stamp() << " Producer sent: " << cnt-1 << endl;
          wait(1, SC_NS);
      }
  }

  SC_CTOR(Producer){
    SC_THREAD(drive_out);
  }
};
