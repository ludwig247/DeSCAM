//
// Created by tobias on 29.11.17.
//

#ifndef PROJECT_EXAMPLE2_H
#define PROJECT_EXAMPLE2_H

#include <Interfaces.h>
#include "systemc.h"
#include "types.h"

struct Example2 : public sc_module {
    SC_HAS_PROCESS(Example2);

    Example2(sc_module_name name) :
            new_frame_found("blocking_in"),
            msg_port("msg_port"),
            section(idle),
            nextsection(idle),
            cnt(0),
            start_of_frame(false) {SC_THREAD(fsm); }

    //Blocking interface
    blocking_in<bool> new_frame_found;
    blocking_in<msg_type> msg_port;

    //Variables
    msg_type msg;
    bool start_of_frame;
    int cnt;

    //Sections
    enum Sections{idle,reading};
    Sections section,nextsection;

    //operationGraph
    void fsm() {
        while (true) {
            section = nextsection;
            if(section == idle){
                std::cout << "idle" << std::endl;
                new_frame_found->read(start_of_frame);
                if(start_of_frame) nextsection = reading;
            }
            if(section == reading) {
                std::cout << "reading" << std::endl;
                msg_port->read(msg);
                ++cnt;
                if(cnt > 4){
                    nextsection = idle;
                    cnt = 0;
                }
            }
            wait(SC_ZERO_TIME);
        }
    };
};


#endif //PROJECT_EXAMPLE2_H
