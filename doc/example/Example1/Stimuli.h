//
// Created by tobias on 29.11.17.
//

#ifndef PROJECT_STIMULI_H
#define PROJECT_STIMULI_H

#include "systemc.h"
#include "Interfaces.h"


struct Stimuli : public sc_module {
    SC_HAS_PROCESS(Stimuli);
    Stimuli(sc_module_name name) :
            block_in("blocking_in"),
            block_out("blocking_out"),
            share_in("shared_in"),
            succ_cnt(0),
            frames_ok(5),
            success(false) { SC_THREAD(fsm); }


    //Blocking interface
    blocking_in<int> block_in;
    blocking_out<int> block_out;
    //Shared interface
    shared_in<bool> share_in;
    //Variables
    int frames_ok;
    int succ_cnt;
    bool success;
    //operationGraph
    void fsm() {
        while (true) {
            frames_ok = (frames_ok * 7 / 5) + 3; //"PseudoRandom number generation"
            if(frames_ok > 100) frames_ok = 1;
            block_out->write(frames_ok);
            success =  block_in->nb_read(succ_cnt);
            std::cout << "@Stimuli: success:" << success << " succ_cnt:" << succ_cnt << " frames_ok:" << frames_ok << std::endl;
            wait(SC_ZERO_TIME);
        }
    };
};

#endif //PROJECT_STIMULI_H
