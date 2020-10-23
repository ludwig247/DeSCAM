//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 11/22/18.
//

#ifndef PROJECT_PLIC_GATEWAY_H
#define PROJECT_PLIC_GATEWAY_H

#include "systemc.h"
#include "Interfaces.h"

class Gateway : public sc_module {
public:

    //Constructor
    SC_HAS_PROCESS(Gateway);

    Gateway(sc_module_name name) :
            IntSig("IntSig"),
            IntReq("IntReq"),
            fromMemoryPending("fromMemoryPending"),
            int_data(false),
            claimed_data(false),
            int_counter(0),
            int_allowed(true),
            comm_status(false)
    {
        SC_THREAD(run);
    }

    slave_in<bool> IntSig;
    master_out<bool> IntReq;
    slave_in<bool> fromMemoryPending;

    bool int_data;
    bool claimed_data;

    int int_counter;
    bool int_allowed;

    bool comm_status;

    void run(){
        while(true){

            if((int_counter > 0) && int_allowed){
                int_allowed = false;
                IntReq->write(true);
            }

            comm_status = fromMemoryPending->nb_read(claimed_data);
            if(comm_status && claimed_data){
                int_allowed = true;
                if(int_counter > 0)
                    int_counter = int_counter - 1;
            }

            comm_status = IntSig->nb_read(int_data);
            if(comm_status && int_data){
                int_counter = int_counter + 1;
            }

        }
    }
};

#endif //PROJECT_PLIC_GATEWAY_H
