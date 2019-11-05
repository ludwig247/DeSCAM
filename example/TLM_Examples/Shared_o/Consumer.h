//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 2/6/19.
//

#ifndef PROJECT_CONSUMER_H
#define PROJECT_CONSUMER_H

struct Consumer : public sc_module {
    SC_HAS_PROCESS(Consumer);

#ifndef DEBUG_TLM
    Consumer(sc_module_name name) :
            in("in") {
        SC_THREAD(fsm);
    }

    shared_in<example_data> in;
    example_data in_data;

    void fsm() {
        while (true) {
            in->get(in_data);
            wait(SC_ZERO_TIME);
        }
    };
#else
    Consumer(sc_module_name name) :
            in("in"),
            in_data(0) {
        SC_THREAD(fsm);
    }

    shared_in<int> in;
    int in_data;

    void fsm() {
        while (true) {
            std::cout << "@" << this->name() << ": read - before : " << in_data << std::endl;
            in->get(in_data);
            std::cout << "@" << this->name() << ": read - after : " << in_data << std::endl;
            
            wait(SC_ZERO_TIME);
        }
    };
#endif
};

#endif //PROJECT_CONSUMER_H
