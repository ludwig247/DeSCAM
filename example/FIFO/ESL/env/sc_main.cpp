#include "systemc.h"
#include "Consumer.h"
#include "Producer.h"
#include "../FIFO.h"

int sc_main(int argc, char *argv[]){
  Blocking<int> prod_out("Producer_out");
  Blocking<int> cons_in("Consumer_in");

  Producer P1("Producer");
  FIFO F1("FIFO");
  Consumer C1("Consumer");

  P1.out(prod_out);

  F1.producer(prod_out);
  F1.consumer(cons_in);

  C1.inp(cons_in);

  sc_start(20, SC_NS);

  return 0;

}
