//
// Created by hesselberg on 9/28/20.
//

#ifndef SCAM_TESTBASIC4_H
#define SCAM_TESTBASIC4_H
struct TestBasic4 : public sc_module {
    //Constructor
    TestBasic4(sc_module_name name) :
            b_out("b_out"),
            var(4) {
        SC_THREAD(fsm);
    }

    SC_HAS_PROCESS(TestBasic4);

    //Out port
    blocking_out<int> b_out;
    //Variable
    bool nb_result;
    int var;

    void fsm() {
        while (true) {
            b_out->try_write(var, nb_result);
            if (nb_result) {
                ++var;
            } else {
                --var;
            }
            wait(SC_ZERO_TIME);
        }
    }
};
#endif //SCAM_TESTBASIC4_H
