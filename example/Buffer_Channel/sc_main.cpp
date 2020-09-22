#include "systemc.h"
#include "Consumer.h"
#include "Producer.h"
#include "Buffer_Channel.h"

int sc_main(int argc, char *argv[]){
    Producer P1("Producer1");
    Producer P2("Producer2");
    Producer P3("Producer3");
    Buffer_Channel<int> channel("Buffer_Channel");
    Consumer C1("Consumer1");

    P1.out.bind(channel);
    P2.out.bind(channel);
    P3.out.bind(channel);
    C1.inp.bind(channel);

    sc_start(200, SC_PS);

    return 0;

}
