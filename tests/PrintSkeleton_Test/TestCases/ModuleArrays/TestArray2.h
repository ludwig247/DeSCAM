//
// Created by hesselberg on 9/28/20.
//

#ifndef SCAM_TESTARRAY2_H
#define SCAM_TESTARRAY2_H

#include "systemc.h"
#include "../../../example/Interfaces/Interfaces.h"

#include "Types.h"

struct TestArray2 : public sc_module {
    blocking_in<int> b_in;
    blocking_out<int> b_out;
    //Constructor
    SC_HAS_PROCESS(TestArray2);

    TestArray2(sc_module_name name) :
            b_in("m_in"),
            b_out("m_out"),
            test(2){
        SC_THREAD(fsm);
    }

    int test;
    int myArray[5];

    void fsm() {
        while (true) {
            b_in->read(test);
            test = test;
            myArray[0] = myArray[test];
            b_out->write(myArray[0]);
        }
    }
};

#endif //SCAM_TESTARRAY2_H
