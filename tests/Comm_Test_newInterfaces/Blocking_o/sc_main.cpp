//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 2/6/19.
//

/** Scenario to run: #define SCENARIO = ?
 *  1 = 4* Blocking_P -> Blocking_C
 *  2 = 4* n_Blocking_P -> n_Blocking_C
 *  3 = 4* Blocking_P -> n_Blocking_C   (not yet)
 *  3 = 4* n_Blocking_P -> Blocking_C   (not yet)
 */

#define SCENARIO 2
//#define BIG_DATA
#define DEBUG_TLM
#define ITERATION_COUNT 10000000

struct example_data {
#ifndef BIG_DATA
    double array;
#else
    double array[10000];
#endif
};

#include "systemc.h"
#include "Interfaces.h"
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
    Blocking<example_data> producer_consumer_1("producer_consumer_1");
    Blocking<example_data> producer_consumer_2("producer_consumer_2");
    Blocking<example_data> producer_consumer_3("producer_consumer_3");
    Blocking<example_data> producer_consumer_4("producer_consumer_4");
#else
    Blocking<int> producer_consumer_1("producer_consumer_1");
    Blocking<int> producer_consumer_2("producer_consumer_2");
    Blocking<int> producer_consumer_3("producer_consumer_3");
    Blocking<int> producer_consumer_4("producer_consumer_4");
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

    std::cout << "@Producer: FINISHED" << std::endl;
    std::cout << "\t\tsend to 1: " << producer.out_1_data - 1 << std::endl;
    std::cout << "\t\tsend to 2: " << producer.out_2_data - 1 << std::endl;
    std::cout << "\t\tsend to 3: " << producer.out_3_data - 1 << std::endl;
    std::cout << "\t\tsend to 4: " << producer.out_4_data - 1 << std::endl;

    std::cout << "\t\t# of iterations: " << producer.cnt << std::endl << std::endl;
    std::cout << "@consumer_1: last read value: " << consumer_1.in_data << std::endl;
    std::cout << "@consumer_2: last read value: " << consumer_2.in_data << std::endl;
    std::cout << "@consumer_3: last read value: " << consumer_3.in_data << std::endl;
    std::cout << "@consumer_4: last read value: " << consumer_4.in_data << std::endl;
    return 0;
}