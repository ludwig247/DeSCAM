//
// Created by tobias on 21.03.18.
//

#ifndef PROJECT_WALKTHROUGH_H
#define PROJECT_WALKTHROUGH_H

#include "systemc.h"
#include "../Interfaces/Interfaces.h"

struct Example: public sc_module{
    //Constructor
    Example(sc_module_name name):
            value(9){SC_THREAD(fsm);}
    SC_HAS_PROCESS(Example);

    //Ports
    blocking_in<int> b_in;
    blocking_out<bool> b_out;

    //Variabless
    int value;

    //FSM
    void fsm(){
        while(true){
            b_in->read(value);
            if(value > 10){
                b_out->write(true);
            }else b_out->write(false);
        }}
};


#endif //PROJECT_WALKTHROUGH_H
