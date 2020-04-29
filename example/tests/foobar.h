//
// Created by ludwig on 05.11.19.
//

#ifndef SCAM_FOOBAR_H
#define SCAM_FOOBAR_H

#include <Interfaces.h>

struct ExampleModule : public sc_module {
    master_out<int> test_out;
    master_in<int> test_in2;
    //Constructor
    SC_CTOR(ExampleModule){
        SC_THREAD(fsm);
    }
    int val;
    void fsm() {
        while (true) {
            insert_state("test");
            test_in2->master_read(val);
            test_out->master_write(~val & 5);
        }
    }
};



#endif //SCAM_FOOBAR_H
