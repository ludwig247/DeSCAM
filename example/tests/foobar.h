//
// Created by ludwig on 05.11.19.
//

#ifndef SCAM_FOOBAR_H
#define SCAM_FOOBAR_H

#include <Interfaces.h>


/*
 *
 */



struct ExampleModule : public sc_module {
    blocking_in<int[32]> input;
    blocking_out<int[32]> output;
    //Constructor
    SC_CTOR(ExampleModule){
        SC_THREAD(fsm);
    }

    int[32] sort(int[32] val) const;

    int val[32];
    void fsm() {
        while (true) {
             input->read(val);
             val = sort(val);

             insert_state("name");

             output->write(val);
        }
    }
};



#endif //SCAM_FOOBAR_H
