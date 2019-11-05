//
// Created by tobias on 29.11.17.
//
#ifndef PROJECT_STIMULI2_H
#define PROJECT_STIMULI2_H

#include "systemc.h"
#include "Interfaces.h"
#include "types.h"


struct Stimuli2 : public sc_module {
    SC_HAS_PROCESS(Stimuli2);
    Stimuli2(sc_module_name name) :
            cnt(0),
            value("value")
{ SC_THREAD(fsm); }


    //Blocking interface
    blocking_out <int> value;
    //Variables
    int cnt;
    //operationGraph
    void fsm() {
        while (true) {
            if(cnt < 1000) ++cnt;
            else cnt=0;
            value->write(cnt);
            //value->nb_write(cnt);


        }
    };
};

#endif //PROJECT_STIMULI_H
