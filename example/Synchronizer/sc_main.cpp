#include "systemc.h"
#include "Consumer.h"
#include "Producer.h"
#include "Synchronizer.h"

int sc_main(int argc, char *argv[]){
  Producer P1("Producer1");
  Producer P2("Producer2");
  Producer P3("Producer3");
  Synchronizer<int> channel("Synchronizer");
  Consumer C1("Consumer");

  P1.out.bind(channel);
  P2.out.bind(channel);
  P3.out.bind(channel);
  C1.inp.bind(channel);

  sc_start(2000, SC_PS);

  return 0;

}
