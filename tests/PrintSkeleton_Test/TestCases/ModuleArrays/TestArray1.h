//
// Created by hesselberg on 9/28/20.
//

#ifndef SCAM_TESTARRAY01_H
#define SCAM_TESTARRAY01_H

#include "systemc.h"
#include "../../../example/Interfaces/Interfaces.h"

#include "Types.h"

struct TestArray1 : public sc_module {
    blocking_in<int> m_in;
    blocking_out<int> m_out;
    //Constructor
    SC_HAS_PROCESS(TestArray1);

    TestArray1(sc_module_name name) :
            m_in("m_in"),
            m_out("m_out"){
        SC_THREAD(fsm);
    }

    int rs1;
    int regfile[2];

    void fsm() {
        while (true) {
            m_in->read(rs1);
            regfile[0] = rs1+1;
            regfile[1] = regfile[0];
            m_out->write(regfile[0]);
        }
    }
};


#endif //SCAM_TESTARRAY01_H
