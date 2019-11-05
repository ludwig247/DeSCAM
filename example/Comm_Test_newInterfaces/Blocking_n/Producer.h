//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 2/6/19.
//

#ifndef PROJECT_PRODUCER_H
#define PROJECT_PRODUCER_H

//#define SCENARIO 2
////#define BIG_DATA
//#define DEBUG_TLM
//#define LIMIT 10000000

#include "systemc.h"
#include "../../Interfaces_new/Interfaces.h"

#if SCENARIO == 1 || SCENARIO == 3

struct Producer : public sc_module {
    SC_HAS_PROCESS(Producer);

#ifndef DEBUG_TLM

    Producer(sc_module_name name) :
            out_1("out_1"),
            out_2("out_2"),
            out_3("out_3"),
            out_4("out_4"),
            cnt(0) {SC_THREAD(fsm); }

    blocking_out<example_data> out_1;
    blocking_out<example_data> out_2;
    blocking_out<example_data> out_3;
    blocking_out<example_data> out_4;
    example_data out_1_data;
    example_data out_2_data;
    example_data out_3_data;
    example_data out_4_data;
    int cnt;

    void fsm() {
        while (true)
        {
            out_1->write(out_1_data);
#ifndef BIG_DATA
            ++out_1_data.array;
#else
            ++out_1_data.array[0];
#endif

            out_2->write(out_2_data);
#ifndef BIG_DATA
            out_2_data.array++;
#else
            ++out_2_data.array[0];
#endif

            out_3->write(out_3_data);
#ifndef BIG_DATA
            out_3_data.array++;
#else
            ++out_3_data.array[0];
#endif

            out_4->write(out_4_data);
#ifndef BIG_DATA
            out_4_data.array++;
#else
            ++out_4_data.array[0];
#endif

            ++cnt;
#ifndef BIG_DATA
            if( (out_1_data.array > LIMIT) && (out_2_data.array > LIMIT) && (out_3_data.array > LIMIT) && (out_4_data.array > LIMIT) ) {
                wait(SC_ZERO_TIME);
                sc_stop();
            }
#else
            if( (out_1_data.array[0] > LIMIT) && (out_2_data.array[0] > LIMIT) && (out_3_data.array[0] > LIMIT) && (out_4_data.array[0] > LIMIT) ) {
                wait(SC_ZERO_TIME);
                sc_stop();
            }
#endif
        }
    };
#else
    Producer(sc_module_name name) :
            out_1("out_1"),
            out_2("out_2"),
            out_3("out_3"),
            out_4("out_4"),
            out_1_data(1),
            out_2_data(1),
            out_3_data(1),
            out_4_data(1),
            cnt(0)
    {SC_THREAD(fsm) }

    blocking_out<int> out_1;
    blocking_out<int> out_2;
    blocking_out<int> out_3;
    blocking_out<int> out_4;
    int out_1_data;
    int out_2_data;
    int out_3_data;
    int out_4_data;
    int cnt;

    void fsm() {
        while (true)
        {
            std::cout << "@Producer: send to 1 - before: " << out_1_data << std::endl;
            out_1->write(out_1_data);
            std::cout << "@Producer: send to 1 - after: " << out_1_data << std::endl;
            ++out_1_data;

            std::cout << "@Producer: send to 2 - before: " << out_2_data << std::endl;
            out_2->write(out_2_data);
            std::cout << "@Producer: send to 2 - after: " << out_2_data << std::endl;
            ++out_2_data;

            std::cout << "@Producer: send to 3 - before: " << out_3_data << std::endl;
            out_3->write(out_3_data);
            std::cout << "@Producer: send to 3 - after: " << out_3_data << std::endl;
            ++out_3_data;

            std::cout << "@Producer: send to 4 - before: " << out_4_data << std::endl;
            out_4->write(out_4_data);
            std::cout << "@Producer: send to 4 - after: " << out_4_data << std::endl;
            ++out_4_data;

            ++cnt;
            if( (out_1_data > LIMIT) && (out_2_data > LIMIT) && (out_3_data > LIMIT) && (out_4_data > LIMIT) ) {
                wait(SC_ZERO_TIME);
                sc_stop();
            }
        }
    };
#endif
};

#elif SCENARIO == 2 || SCENARIO == 4

struct Producer : public sc_module {
    SC_HAS_PROCESS(Producer);

#ifndef DEBUG_TLM
    Producer(sc_module_name name) :
            out_1("out_1"),
            out_2("out_2"),
            out_3("out_3"),
            out_4("out_4"),
            out_1_status(false),
            out_2_status(false),
            out_3_status(false),
            out_4_status(false),
            cnt(0) {SC_THREAD(fsm); }

    blocking_out<example_data> out_1;
    blocking_out<example_data> out_2;
    blocking_out<example_data> out_3;
    blocking_out<example_data> out_4;
    bool out_1_status;
    bool out_2_status;
    bool out_3_status;
    bool out_4_status;
    example_data out_1_data;
    example_data out_2_data;
    example_data out_3_data;
    example_data out_4_data;
    int cnt;

    void fsm() {
#ifndef BIG_DATA
        out_1_data.array = 1;
        out_2_data.array = 1;
        out_3_data.array = 1;
        out_4_data.array = 1;
#else
        out_1_data.array[0] = 1;
        out_2_data.array[0] = 1;
        out_3_data.array[0] = 1;
        out_4_data.array[0] = 1;
#endif
        while (true)
        {
            out_1->try_write(out_1_data, out_1_status);
            if(out_1_status) {
#ifndef BIG_DATA
                ++out_1_data.array;
#else
                ++out_1_data.array[0];
#endif
            }

            out_2->try_write(out_2_data, out_2_status);
            if(out_2_status) {
#ifndef BIG_DATA
                ++out_2_data.array;
#else
                ++out_2_data.array[0];
#endif
            }

            out_3->try_write(out_3_data, out_3_status);
            if(out_3_status) {
#ifndef BIG_DATA
                ++out_3_data.array;
#else
                ++out_3_data.array[0];
#endif
            }

            out_4->try_write(out_4_data, out_4_status);
            if(out_4_status) {
#ifndef BIG_DATA
                ++out_4_data.array;
#else
                ++out_4_data.array[0];
#endif
            }

            ++cnt;
#ifndef BIG_DATA
            if( (out_1_data.array > LIMIT) && (out_2_data.array > LIMIT) && (out_3_data.array > LIMIT) && (out_4_data.array > LIMIT) ) {
                wait(SC_ZERO_TIME);
                sc_stop();
            }
#else
            if( (out_1_data.array[0] > LIMIT) && (out_2_data.array[0] > LIMIT) && (out_3_data.array[0] > LIMIT) && (out_4_data.array[0] > LIMIT) ) {
                wait(SC_ZERO_TIME);
                sc_stop();
            }
#endif
        }
    };
#else
    Producer(sc_module_name name) :
            out_1("out_1"),
            out_2("out_2"),
            out_3("out_3"),
            out_4("out_4"),
            out_1_status(false),
            out_2_status(false),
            out_3_status(false),
            out_4_status(false),
            out_1_data(1),
            out_2_data(1),
            out_3_data(1),
            out_4_data(1),
            cnt(0) {SC_THREAD(fsm); }

    blocking_out<int> out_1;
    blocking_out<int> out_2;
    blocking_out<int> out_3;
    blocking_out<int> out_4;
    bool out_1_status;
    bool out_2_status;
    bool out_3_status;
    bool out_4_status;
    int out_1_data;
    int out_2_data;
    int out_3_data;
    int out_4_data;
    int cnt;

    void fsm() {
        while (true)
        {
            std::cout << "@Producer: send to 1 - before: " << out_1_data << std::endl;
            out_1->try_write(out_1_data, out_1_status);
            if(out_1_status) {
                std::cout << "@Producer: send to 1 - after (successful): " << out_1_data << std::endl;
                ++out_1_data;
            }
//            else
//                std::cout << "@Producer: send to 1 - after (Not successful): " << out_1_data << std::endl;

            std::cout << "@Producer: send to 2 - before: " << out_2_data << std::endl;
            out_2->try_write(out_2_data, out_2_status);
            if(out_2_status) {
                std::cout << "@Producer: send to 2 - after (successful): " << out_2_data << std::endl;
                ++out_2_data;
            }
//            else
//                std::cout << "@Producer: send to 2 - after (Not successful): " << out_2_data << std::endl;

            std::cout << "@Producer: send to 3 - before: " << out_3_data << std::endl;
            out_3->try_write(out_3_data, out_3_status);
            if(out_3_status) {
                std::cout << "@Producer: send to 3 - after (successful): " << out_3_data << std::endl;
                ++out_3_data;
            }
//            else
//                std::cout << "@Producer: send to 3 - after (Not successful): " << out_3_data << std::endl;

            std::cout << "@Producer: send to 4 - before: " << out_4_data << std::endl;
            out_4->try_write(out_4_data, out_4_status);
            if(out_4_status) {
                std::cout << "@Producer: send to 4 - after (successful): " << out_4_data << std::endl;
                ++out_4_data;
            }
//            else
//                std::cout << "@Producer: send to 4 - after (Not successful): " << out_4_data << std::endl;

            ++cnt;
            if( (out_1_data > LIMIT) && (out_2_data > LIMIT) && (out_3_data > LIMIT) && (out_4_data > LIMIT) ) {
                wait(WAIT_TIME, SC_PS);
//                wait(SC_ZERO_TIME);
                sc_stop();
            }
        }
    };

#endif
};

#endif

#endif //PROJECT_PRODUCER_H
