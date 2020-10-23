//
// Created by hesselberg on 9/28/20.
//

#ifndef SCAM_TESTARRAY3_H
#define SCAM_TESTARRAY3_H

#include "Interfaces.h"


struct TestArray03 : public sc_module {
    blocking_in<int[5]> b_in;
    blocking_out<int> b_out;
    //Constructor
    SC_HAS_PROCESS(TestArray03);

    TestArray03(sc_module_name name) :
            b_in("m_in"),
            b_out("m_out"),
            test(2){
        SC_THREAD(fsm);
    }

    int test;
    int myArray[5];

    void fsm() {
        while (true) {
            b_in->read(myArray);
            test = myArray[0] + 1 +1 ;
            b_out->write(test);
        }
    }
};
#endif //SCAM_TESTARRAY3_H
