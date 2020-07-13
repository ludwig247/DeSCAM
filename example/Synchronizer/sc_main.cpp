#include "systemc.h"
#include "Consumer.h"
#include "Producer.h"
#include "Synchronizer.h"

int sc_main(int argc, char *argv[]){
  Producer P1("Producer1");
  Producer P2("Producer2");
  Synchronizer<int> channel("Synchronizer", 2);
  Consumer C1("Consumer");

  P1.out.bind(channel);
  P2.out.bind(channel);
  C1.inp.bind(channel);

  sc_start(200, SC_PS);

  return 0;

}
