//
// Created by wezel on 8/12/20.
//

#ifndef DESCAM_INITIALIZER_DUMMY_H
#define DESCAM_INITIALIZER_DUMMY_H

#include "types.h"
#include "systemc.h"
#include "AHB_Bus_Channel.h"
#include "Interfaces.h"

SC_MODULE(Initializer_Dummy){
    sc_port<AHB_Bus_Channel_Dummy_if> init_out;

    void initialize(){
        while(true){
            init_out->dummyFunc();
        }
    }

    SC_CTOR(Initializer_Dummy){
        SC_THREAD(initialize);
    }
};

#endif //DESCAM_INITIALIZER_DUMMY_H
