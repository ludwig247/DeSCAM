//
// Created by tobias on 29.11.17.
//
#ifndef PROJECT_STIMULI_H
#define PROJECT_STIMULI_H

#include "systemc.h"
#include "Interfaces.h"
#include "types.h"


struct Stimuli : public sc_module {
    SC_HAS_PROCESS(Stimuli);
    Stimuli(sc_module_name name) :
            var(false),
            slave_in1("slave_in1")
{ SC_THREAD(fsm); }


    //Blocking interface
    slave_in <bool> slave_in1;
    //Variables
    bool var;
    bool ret;

    //operationGraph
    void fsm() {
        while (true) {
            ret = slave_in1->nb_read(var);
            if(var && ret){
                std::cout << "Received true after " << sc_delta_count() << " delta cycles" << std::endl;
                std::cout << "Stopping execution" << std::endl;
                sc_stop();
            }
        }
    };
};

#endif //PROJECT_STIMULI_H
