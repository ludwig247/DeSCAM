//
// Created by ludwig on 10.10.17.
//

#ifndef PROJECT_BLOCKING_2_STAGE_H
#define PROJECT_BLOCKING_2_STAGE_H


#include "systemc.h"
#include "../Interfaces/Interfaces.h"


struct pipeline : public sc_module {
    blocking_in<int> b_in;
    blocking_out<int> b_out;
    //Constructor
    SC_HAS_PROCESS(pipeline);

    pipeline(sc_module_name name) :
            b_in("b_in"),
            b_out("b_out"){
        SC_THREAD(fsm);
    }

    int result;

    void fsm() {
        while (true) {
          b_in->read(result);
          result=result+1;
          b_out->write(result);
        }
    }
};

#endif //PROJECT_BLOCKING_2_STAGE_H
