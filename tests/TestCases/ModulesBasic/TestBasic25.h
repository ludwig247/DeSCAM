//
// Created by hesselberg on 9/30/20.
//

#ifndef SCAM_TESTBASIC25_H
#define SCAM_TESTBASIC25_H

#include "systemc.h"
#include "Interfaces.h"
#include "../Types.h"

struct TestBasic25 : public sc_module {

    //Constructor
    SC_HAS_PROCESS(TestBasic25);

    TestBasic25(sc_module_name name) :
            reg_in("reg_in"),
            alu_out("alu_out"),
            alu_in("alu_in"),
            reg_out("reg_out"),
            reg_inData(0),
            alu_inData(0) {
        SC_THREAD(fsm);
    }

    //Out-port
    master_in<int> reg_in;
    master_out<int> alu_out;
    master_in<int> alu_in;
    master_out<int> reg_out;

    //Vars
    int reg_inData;
    int alu_inData;

    void fsm() {
        while (true) {
            reg_in->master_read(reg_inData);
            alu_out->master_write(reg_inData + 5);//state_6
            alu_in->master_read(alu_inData);
            reg_out->master_write(alu_inData);//state_8
        }
    }
};

#endif //SCAM_TESTBASIC25_H
