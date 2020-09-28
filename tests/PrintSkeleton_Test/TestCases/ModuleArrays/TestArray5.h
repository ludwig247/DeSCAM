//
// Created by hesselberg on 9/28/20.
//

#ifndef SCAM_TESTARRAY5_H
#define SCAM_TESTARRAY5_H

#include "systemc.h"
#include "Interfaces.h"
#include "../Types.h"

struct TestArray5 : public sc_module {
    blocking_in<int> b_in;
    blocking_out<int[2]> b_out;
    //Constructor
    SC_HAS_PROCESS(TestArray5);

    TestArray5(sc_module_name name) :
            b_in("m_in"),
            b_out("m_out"){
        SC_THREAD(fsm);
    }

    int test;
    int myArray[2];
    bool succ;

    void fsm() {
        while (true) {
            b_in->try_read(test);
            myArray[0] = test + myArray[1];
            myArray[1]  = test;
            b_out->try_write(myArray, succ);
            if(succ) ++myArray[1];
        }
    }
};
#endif //SCAM_TESTARRAY5_H
