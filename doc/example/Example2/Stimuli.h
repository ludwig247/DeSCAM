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
            new_frame_found("blocking_in"),
            msg_port("msg_port")
{ SC_THREAD(fsm); }


    //Blocking interface
    blocking_out<bool> new_frame_found;
    blocking_out<msg_type> msg_port;
    //Variables
    msg_type msg;

    //operationGraph
    void fsm() {
        while (true) {
            new_frame_found->write(false);
            new_frame_found->write(false);
            new_frame_found->write(true);
            msg_port->write(msg);
            ++msg.addr;
            --msg.data;
            msg_port->write(msg);
            ++msg.addr;
            --msg.data;
            msg_port->write(msg);
            ++msg.addr;
            --msg.data;
            msg_port->write(msg);
            ++msg.addr;
            --msg.data;
            msg_port->write(msg);
            ++msg.addr;
            --msg.data;
            new_frame_found->write(false);
            new_frame_found->write(false);
            new_frame_found->write(false);
            new_frame_found->write(false);
            wait(SC_ZERO_TIME);
        }
    };
};

#endif //PROJECT_STIMULI_H
