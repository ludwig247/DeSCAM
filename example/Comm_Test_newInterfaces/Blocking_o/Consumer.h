//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 2/6/19.
//

#ifndef PROJECT_CONSUMER_H
#define PROJECT_CONSUMER_H

//#define SCENARIO 2
////#define BIG_DATA
//#define DEBUG_TLM
#include "systemc.h"
#include "../../Interfaces/Interfaces.h"

#if SCENARIO == 1 || SCENARIO == 4

struct Consumer : public sc_module {
    SC_HAS_PROCESS(Consumer);

#ifndef DEBUG_TLM
    Consumer(sc_module_name name) :
            in("in"),
            cnt(0) {
        SC_THREAD(fsm);
    }

    blocking_in<example_data> in;
    example_data in_data;
    int cnt;

    void fsm() {
        while (true) {
            in->read(in_data);
            ++cnt;
        }
    };
#else
    Consumer(sc_module_name name) :
            in("in"),
            in_data(0),
            cnt(0) {
        SC_THREAD(fsm)
    }

    blocking_in<int> in;
    int in_data;
    int cnt;

    void fsm() {
        while (true) {
            std::cout << "@" << this->name() << ": read - before : " << in_data << std::endl;
            in->read(in_data);
            std::cout << "@" << this->name() << ": read - after : " << in_data << std::endl;
            ++cnt;
        }
    };
#endif
};

#elif SCENARIO == 2 || SCENARIO == 3
struct Consumer : public sc_module {
    SC_HAS_PROCESS(Consumer);

#ifndef DEBUG_TLM
    Consumer(sc_module_name name) :
            in_status(false),
            in("in"),
            cnt(0) {
        SC_THREAD(fsm)
    }

    blocking_in<example_data> in;
    example_data in_data;
    bool in_status;
    int cnt;

    void fsm() {
        while (true) {
            in_status = in->nb_read(in_data);
            ++cnt;
        }
    };
#else

    Consumer(sc_module_name name) :
            in("in"),
            in_status(false),
            in_data(0),
            cnt(0) {
        SC_THREAD(fsm)
    }

    blocking_in<int> in;
    int in_data;
    bool in_status;
    int cnt;

    void fsm() {
        while (true) {
            std::cout << "@" << this->name() << ": read - before : " << in_data << std::endl;
            in_status = in->nb_read(in_data);
            if(in_status)
                std::cout << "@" << this->name() << ": read - after (successful) : " << in_data << std::endl;
            else
                std::cout << "@" << this->name() << ": read - after (Not successful): " << in_data << std::endl;

            ++cnt;
        }
    };
#endif
};
#endif

#endif //PROJECT_CONSUMER_H
