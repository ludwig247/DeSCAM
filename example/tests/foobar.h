//
// Created by ludwig on 05.11.19.
//

#ifndef SCAM_FOOBAR_H
#define SCAM_FOOBAR_H

#include <Interfaces.h>

struct ExampleModule : public sc_module {
    master_out<int[7]> test_out;
    master_in<int> test_in2;
    //Constructor
    SC_CTOR(ExampleModule){
        SC_THREAD(fsm);
    }
    int myArray[7];
    void fsm() {
        while (true) {
//            test_in2->master_read(myArray[0], "s0");
//            test_in2->master_read(myArray[1], "s1");
//            test_in2->master_read(myArray[2], "s2");
//            test_in2->master_read(myArray[3], "s3");
//            test_in2->master_read(myArray[4], "s4");
//            test_in2->master_read(myArray[5], "s5");
            test_in2->master_read(myArray[6], "s6");
            myArray[5] = myArray[6] % 5;
            test_out->master_write(myArray, "out_state");
        }
    }
};



#endif //SCAM_FOOBAR_H
