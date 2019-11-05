//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 2/8/19.
//

/** Scenario to run: #define SCENARIO = ?
 *  1 = 4* Master_P -> Slave_C
 *  2 = 4* Slave_P  -> Master_C
 *  3 = 4* Slave_P  -> Slave_C
 */

#define SCENARIO 3
#define BIG_DATA
//#define DEBUG_TLM
#define ITERATION_COUNT 10000000

struct example_data {
#ifndef BIG_DATA
    double array;
#else
    double array[10000];
#endif
};


#include "systemc.h"
#include "../../Interfaces/Interfaces.h"
#include "Consumer.h"
#include "Producer.h"


using namespace std;

int sc_main(int, char **) {
    //Generating/Receiving messages
    Producer producer("producer");
    Consumer consumer_1("consumer_1");
    Consumer consumer_2("consumer_2");
    Consumer consumer_3("consumer_3");
    Consumer consumer_4("consumer_4");

    //Channels
#ifndef DEBUG_TLM
    MasterSlave<example_data> producer_consumer_1("producer_consumer_1");
    MasterSlave<example_data> producer_consumer_2("producer_consumer_2");
    MasterSlave<example_data> producer_consumer_3("producer_consumer_3");
    MasterSlave<example_data> producer_consumer_4("producer_consumer_4");
#else
    MasterSlave<int> producer_consumer_1("producer_consumer_1");
    MasterSlave<int> producer_consumer_2("producer_consumer_2");
    MasterSlave<int> producer_consumer_3("producer_consumer_3");
    MasterSlave<int> producer_consumer_4("producer_consumer_4");
#endif
    producer.out_1(producer_consumer_1);
    consumer_1.in(producer_consumer_1);

    producer.out_2(producer_consumer_2);
    consumer_2.in(producer_consumer_2);

    producer.out_3(producer_consumer_3);
    consumer_3.in(producer_consumer_3);

    producer.out_4(producer_consumer_4);
    consumer_4.in(producer_consumer_4);

    sc_start(); //Start simulation
    return 0;
}