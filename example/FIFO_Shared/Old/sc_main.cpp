#include "systemc.h"
#include "Consumer.h"
#include "Producer.h"
#include "FIFO_Channel.h"

int sc_main(int argc, char *argv[]){
  Producer P1("Producer");
  FIFO_Channel<int> channel("FIFO_Shared", 4);
  Consumer C1("Consumer");

  P1.out.bind(channel);
  C1.inp.bind(channel);

  sc_start(20, SC_NS);

  return 0;

}
