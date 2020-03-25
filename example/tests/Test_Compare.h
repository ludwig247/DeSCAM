//
// Created by ludwig on 10.10.17.
//

#ifndef PROJECT_SLAVEDAVEBAVE_H_H
#define PROJECT_SLAVEDAVEBAVE_H_H


#include "systemc.h"
#include "../Interfaces/Interfaces.h"
#define ADD_HEX 0x100


unsigned int compute(unsigned int param, int param2) {
    if(param > 10 && param2 > 10){
        return param +1 ;
    }else return param + static_cast<unsigned int>(param2);
}

int compute2(int param, unsigned int param2){
    //param = param + static_cast<int>(param);
    return param+3;
}

bool compute3(bool param, unsigned int val){

    if( (val > 0) && !param) return false;
    else return true;
}




SC_MODULE(TestTernary01) {
    blocking_in<int> data_in;
    blocking_out<int> valid_out;
    shared_out<bool> data_out;

    int value_in;
    int new_value;
    bool valid;

    SC_CTOR(TestTernary01){
        SC_THREAD(fsm);
    }

    void fsm() {
        while (true) {
            data_in->try_read(value_in, valid);
            new_value = (valid) ? (value_in + 1) : value_in + 0;
            if(new_value > 5){
                new_value = new_value + 1;
            }
            data_out->set(valid);
            valid_out->write(new_value, "output1");
            new_value = value_in > 0 ? 1 : 0;
            data_out->set(valid);
            valid_out->write(new_value, "output2");

        }
    }
};


#endif //PROJECT_SLAVEDAVEBAVE_H_H
