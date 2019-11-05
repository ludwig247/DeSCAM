//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 2/6/19.
//

#ifndef PROJECT_CONSUMER_H
#define PROJECT_CONSUMER_H

#if SCENARIO == 2
struct Consumer : public sc_module {
    SC_HAS_PROCESS(Consumer);

#ifndef DEBUG_TLM
    Consumer(sc_module_name name) :
            in("in") {
        SC_THREAD(fsm);
    }

    master_in<example_data> in;
    example_data in_data;

    void fsm() {
        while (true) {
            in->read(in_data);
        }
    };
#else
    Consumer(sc_module_name name) :
            in("in"),
            in_data(0) {
        SC_THREAD(fsm);
    }

    master_in<int> in;
    int in_data;

    void fsm() {
        while (true) {
            std::cout << "@" << this->name() << ": read - before : " << in_data << std::endl;
            in->read(in_data);
            std::cout << "@" << this->name() << ": read - after : " << in_data << std::endl;
        }
    };
#endif
};

#elif SCENARIO == 1 || SCENARIO == 3

struct Consumer : public sc_module {
    SC_HAS_PROCESS(Consumer);

#ifndef DEBUG_TLM
    Consumer(sc_module_name name) :
            in("in") {
        SC_THREAD(fsm);
    }

    slave_in<example_data> in;
    example_data in_data;

    void fsm() {
        while (true) {
            in->nb_read(in_data);
        }
    };
#else
    Consumer(sc_module_name name) :
            in("in"),
            in_data(0) {
        SC_THREAD(fsm);
    }

    slave_in<int> in;
    int in_data;

    void fsm() {
        while (true) {
            std::cout << "@" << this->name() << ": read - before : " << in_data << std::endl;
            if(in->nb_read(in_data))
                std::cout << "@" << this->name() << ": read - after : " << in_data << std::endl;
        }
    };
#endif
};

#endif

#endif //PROJECT_CONSUMER_H
