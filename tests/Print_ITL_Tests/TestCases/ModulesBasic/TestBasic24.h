//
// Created by hesselberg on 9/30/20.
//

#ifndef SCAM_TESTBASIC24_H
#define SCAM_TESTBASIC24_H


/// checking a master_in after a master_out => color master_out
struct TestBasic24 : public sc_module {

    //Constructor
    SC_HAS_PROCESS(TestBasic24);

    TestBasic24(sc_module_name name) :
            b_out("b_out"),
            reg_in("reg_in"),
            alu_out("alu_out"),
            alu_in("alu_in"),
            reg_out("reg_out"),
            reg_inData(0),
            alu_inData(0),
            var1(5) {
        SC_THREAD(fsm);
    }

    //Out-port
    blocking_out<int> b_out;
    master_in<int> reg_in;
    master_out<int> alu_out;
    master_in<int> alu_in;
    master_out<int> reg_out;

    //Vars
    int var1;
    int reg_inData;
    int alu_inData;

    void fsm() {
        while (true) {
            b_out->write(var1);//state_6
            reg_in->master_read(reg_inData);
            alu_out->master_write(reg_inData + 5);//state_8
            alu_in->master_read(alu_inData);
            reg_out->master_write(alu_inData);
        }
    }
};


#endif //SCAM_TESTBASIC24_H
