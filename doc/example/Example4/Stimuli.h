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
            slave_out1("slave_out1"),
            slave_out2("slave_out2"),
            report_in("report_in")
{ SC_THREAD(fsm); }


    //Blocking interface
    slave_out <bool> slave_out1;
    slave_out <bool> slave_out2;
    slave_in <bool> report_in;
    //Variables
    bool var;
    bool ret;
    bool succ;
    bool result;
    //operationGraph
    void fsm() {
        while (true) {

            var = (rand()%2)==1;
            std::cout << "#1" << std::endl;
            slave_out2->nb_write(false);
            std::cout << "#2" << std::endl;
            slave_out1->nb_write(var);
            std::cout << "#3" << std::endl;
            succ = report_in->nb_read(result);
            std::cout << "Succ:" << succ << "Result" << result << std::endl;

            if(succ && result){
                std::cout << "Stop after " << sc_delta_count() << "delta cycles" << std::endl;
                sc_stop();
            }
        }
    };
};

#endif //PROJECT_STIMULI_H
