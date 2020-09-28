//
// Created by hesselberg on 9/28/20.
//

#ifndef SCAM_ARRAY00_H
#define SCAM_ARRAY00_H

#include "systemc.h"
#include "Interfaces.h"
#include "../Types.h"

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

#endif //SCAM_ARRAY00_H
