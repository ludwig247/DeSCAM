//
// Created by Paulius Morkunas on 17.04.19.
//

#ifndef PROJECT_BLOCKING_3_STAGE_H
#define PROJECT_BLOCKING_3_STAGE_H


#include "systemc.h"
#include "../../Interfaces/Interfaces.h"

struct pipeline : public sc_module {
    blocking_in<int> b_in1;
    blocking_in<int> b_in2;
    blocking_out<int> b_out;

    //Constructor
    SC_HAS_PROCESS(pipeline);

    pipeline(sc_module_name name) :
            b_in1("b_in1"),
			b_in2("b_in2"),
            b_out("b_out") {
        SC_THREAD(fsm);
    }

    int in1;
    int in2;
    void fsm() {
        while (true) {
			b_in1->read(in1);
			b_in2->read(in2);
          	b_out->write(in1 + in2);
        }
    }
};

#endif //PROJECT_BLOCKING_3_STAGE_H
