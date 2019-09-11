//
// Created by tobias on 29.11.17.
//

#ifndef PROJECT_EXAMPLE3_H
#define PROJECT_EXAMPLE3_H

#include "systemc.h"
#include "Interfaces.h"
#include "types.h"

struct Example3 : public sc_module {
    SC_HAS_PROCESS(Example3);

    Example3(sc_module_name name) :
            master_out1("master_out1"),
            value_in("value_in"),
            var(10),
            section(idle),
            nextsection(idle){SC_THREAD(fsm); }

    //Blocking interface
    blocking_in<int> value_in;
    master_out <bool> master_out1;

    //Variables
    int var;
    bool ret;

    //Sections
    enum Sections{idle,reading};
    Sections section,nextsection;

    //operationGraph
    void fsm() {
        while (true) {
            section = nextsection;
            if(section == idle){
                ret = value_in->nb_read(var);
                nextsection = reading;
            }
            if(section == reading) {
                if(var == 0) master_out1->write(true);
                else master_out1->write(false);
                nextsection=idle;
            }
        }
    };
};


#endif //PROJECT_EXAMPLE3_H
