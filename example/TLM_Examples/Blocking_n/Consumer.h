//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 2/6/19.
//

#ifndef PROJECT_CONSUMER_H
#define PROJECT_CONSUMER_H

#if SCENARIO == 1

struct Consumer : public sc_module {
    SC_HAS_PROCESS(Consumer);

#ifndef DEBUG_TLM
    Consumer(sc_module_name name) :
            in("in") {
        SC_THREAD(fsm);
    }

    blocking_in<example_data> in;
    example_data in_data;

    void fsm() {
        while (true) {
            in->read(in_data);
        }
    };
#else
    Consumer(sc_module_name name) :
            in("in"),
            in_data(5) {
        SC_THREAD(fsm);
    }

    blocking_in<int> in;
    int in_data;

    void fsm() {
        while (true) {
//            std::cout << "@" << this->name() << ": read - before : " << in_data << std::endl;
            in->read(in_data);
            std::cout << "@" << this->name() << ": read - after : " << in_data << std::endl;
        }
    };
#endif
};

#elif SCENARIO == 2
struct Consumer : public sc_module {
    SC_HAS_PROCESS(Consumer);

#ifndef DEBUG_TLM
    Consumer(sc_module_name name) :
            in("in") {
        SC_THREAD(fsm);
    }

    blocking_in<example_data> in;
    example_data in_data;

    void fsm() {
        while (true) {
            if(in->peek()){
                in->read(in_data);
            } else {
                wait(SC_ZERO_TIME);
            }
        }
    };
#else

    Consumer(sc_module_name name) :
            in("in"),
            successful(false),
            in_data(5) {
        SC_THREAD(fsm);
    }

    blocking_in<int> in;
    int in_data;
    bool successful;

    void fsm() {
        while (true) {

            std::cout << "@" << this->name() << ": read - before : " << in_data << std::endl;
            in->read_no_wait(in_data, successful);
            if(successful)
                std::cout << "@" << this->name() << ": read - after (successful): " << in_data << std::endl;
            else
                std::cout << "@" << this->name() << ": read - after (Not successful): " << in_data << std::endl;

//            if(in->peek()){
//                std::cout << "@" << this->name() << ": read - before : " << in_data << std::endl;
//                in->read(in_data);
//                std::cout << "@" << this->name() << ": read - after : " << in_data << std::endl;
//            } else {
//                std::cout << "@" << this->name() << ": Nothing to read!!" << std::endl;
//                wait(SC_ZERO_TIME);
//            }
        }
    };
#endif
};
#endif

#endif //PROJECT_CONSUMER_H
