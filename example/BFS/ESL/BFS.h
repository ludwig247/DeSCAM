//
// Created by Tobias Jauch on 28.04.2020.
//
#include "../../Interfaces/Interfaces.h"
#include "systemc.h"

#ifndef PROJECT_BUS_H
#define PROJECT_BUS_H

struct BFS : public sc_module {

    //In-port
    blocking_in<bus_req_t> data_in_in;

    //Out-port
    blocking_out<bus_resp_t> data_out;

    //Variables


    //Algorithm
    void BFS(){

    }


    //Constructor
    SC_HAS_PROCESS(BFS);

    BFS(sc_module_name name) :
             {
        SC_THREAD(fsm);
    }

    void fsm() {

        while (true) {


            //wait(SC_ZERO_TIME);
        }
    }
};


#endif
