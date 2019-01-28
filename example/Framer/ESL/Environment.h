//
// Created by ludwig on 04.07.17.
//

#ifndef PROJECT_ENVIRONMENT_H
#define PROJECT_ENVIRONMENT_H
//

#include "systemc.h"
#include "../../Interfaces/Interfaces.h"


struct Environment : public sc_module {
//Constructor
    SC_HAS_PROCESS(Environment);

    Environment(sc_module_name name) {
        SC_THREAD(fsm);
    }

//Vars
    int max_miss_uP_tmp;
    marker_t data_word_tmp;
    int cnt;
    Config config;
//In-port
    master_out<marker_t> data_word;
//Output
    shared_out<Config> config_out;

    void fsm() {
        while (true) {
            config.LOFreset = 8;
            config.LOFset = 8;
            config_out->set(config);
            data_word_tmp.isMarker = rand() % 2;
            data_word_tmp.markerAlignment = rand() % 5;
            //std::cout << data_word_tmp.isMarker << "," << data_word_tmp.markerAlignment << std::endl;
            data_word->write(data_word_tmp);
            if (cnt < 10000000) {
                cnt++;
            } else {
                //std::cout << "cnt = 10000000" << std::endl;
                sc_stop();
            }
            wait(SC_ZERO_TIME);
        }
    }
};

#endif //PROJECT_ENVIRONMENT_H


