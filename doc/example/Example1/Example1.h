//
// Created by tobias on 29.11.17.
//

#ifndef PROJECT_EXAMPLE1_H
#define PROJECT_EXAMPLE1_H

#include "systemc.h"
#include "../../../example/Interfaces/Interfaces.h"

struct Example1 : public sc_module {
    SC_HAS_PROCESS(Example1);

    Example1(sc_module_name name) :
            block_in("blocking_in"),
            block_out("blocking_out"),
            share_out("shared_out"),
            succ_cnt(0),
            frames_ok(0),
            success(false) {SC_THREAD(fsm); }

    //Blocking interface
    blocking_in<int> block_in;
    blocking_out<int> block_out;
    //Shared interface
    shared_out<bool> share_out;
    //Variables
    int frames_ok;
    int succ_cnt;
    bool success;

    //operationGraph
    void fsm() {
        while (true) {
            block_in->read(frames_ok);
            if (frames_ok > 10) {
                ++succ_cnt;
                success = block_out->nb_write(succ_cnt);
                std::cout << "@Example: success:" << success << " succ_cnt:" << succ_cnt << " frames_ok:" << frames_ok << std::endl;
                share_out->set(success);
            } else succ_cnt = 0;
            wait(SC_ZERO_TIME);
        }
    };
};


#endif //PROJECT_EXAMPLE1_H
