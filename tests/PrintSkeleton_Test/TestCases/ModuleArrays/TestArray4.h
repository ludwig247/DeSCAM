//
// Created by hesselberg on 9/28/20.
//

#ifndef SCAM_TESTARRAY4_H
#define SCAM_TESTARRAY4_H

#include "systemc.h"
#include "../../../example/Interfaces/Interfaces.h"

#include "Types.h"

struct TestArray4 : public sc_module {
    blocking_in<int> m_in;
    blocking_out<int[5]> m_out;
    //Constructor
    SC_HAS_PROCESS(TestArray4);

    TestArray4(sc_module_name name) :
            m_in("m_in"),
            m_out("m_out"){
        SC_THREAD(fsm);
    }

    int test;
    int myArray[5];

    void fsm() {
        while (true) {
            m_in->read(test);
            myArray[0] = test;
            m_out->write(myArray);

        }
    }
};
#endif //SCAM_TESTARRAY4_H
