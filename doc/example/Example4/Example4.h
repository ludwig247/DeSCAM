//
// Created by tobias on 29.11.17.
//

#ifndef PROJECT_EXAMPLE4_H
#define PROJECT_EXAMPLE4_H

#include "systemc.h"
#include "Interfaces.h"
#include "types.h"

struct Example4 : public sc_module {
    SC_HAS_PROCESS(Example4);

    Example4(sc_module_name name) :
            master_in1("master_in1"),
            value_in("value_in"),
            report_out("report_out"),
            var(10),
            section(idle),
            value(false),
            nextsection(idle){SC_THREAD(fsm); }

    //Blocking interface
    blocking_in <int> value_in;
    master_in <bool> master_in1;
    master_in <bool> master_in2;
    master_out <bool> report_out;

    //Variables
    int var;
    bool value;
    bool succ;

    //Sections
    enum Sections{idle,reading};
    Sections section,nextsection;

    //operationGraph
    void fsm() {
        while (true) {
            section = nextsection;
            if(section == idle){
                report_out->write(false);
                succ = value_in->nb_read(var);
                nextsection = reading;
            }
            if(section == reading) {
                if(var == 0) master_in1->read(value);
                if(value == true){
                    report_out->write(true);
                }
                nextsection = idle;
            }
        }
    };
};


#endif //PROJECT_EXAMPLE4_H
