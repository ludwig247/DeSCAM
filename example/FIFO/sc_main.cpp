#include "systemc.h"
#include "Consumer.h"
#include "Producer.h"
#include "FIFO.h"

int sc_main(int argc, char *argv[]){
  Producer P1("Producer");
  FIFO<int> channel("FIFO", 3);
  Consumer C1("Consumer");

  P1.out.bind(channel);
  C1.inp.bind(channel);

  sc_start(200, SC_PS);

  return 0;

}
