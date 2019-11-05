//
// Created by ludwig on 05.11.19.
//

#ifndef SCAM_FOOBAR_H
#define SCAM_FOOBAR_H

#include <Interfaces.h>

struct TestArray0 : public sc_module {
    blocking_in<int> b_in;
    blocking_out<int[2]> b_out;
    //Constructor
    SC_HAS_PROCESS(TestArray0);

    TestArray0(sc_module_name name) :
            b_in("m_in"),
            b_out("m_out"){
        SC_THREAD(fsm);
    }

    int test;
    int myArray[2];

    void fsm() {
        while (true) {
            b_in->read(test);
            myArray[0] = test + myArray[1];
            myArray[1]  = test;
            b_out->write(myArray);
        }
    }
};



#endif //SCAM_FOOBAR_H
