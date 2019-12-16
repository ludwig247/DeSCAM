//
// Created by tobias on 13.12.19.
//

#ifndef DESCAM_MODULESTATENAMES_H
#define DESCAM_MODULESTATENAMES_H

#include "systemc.h"
#include "../../../example/Interfaces/Interfaces.h"

SC_MODULE(ModuleStateName01) {
        blocking_in<int> b_in;
        blocking_out<int> b_out;

        SC_CTOR(ModuleStateName01){
            SC_THREAD(fsm);
        }
        int val;
        bool res;
        void fsm() {
            while (true) {
                b_in->read(val);
                b_in->read(val,"idle");
                b_in->try_read(val,res,"wait");
                b_out->write(val);
                b_out->write(val,"store");
                b_out->try_write(val,res,"load");
            }
        }
};

SC_MODULE(ModuleStateName02) {
    master_in<int> m_in;
    master_out<int> m_out;

    SC_CTOR(ModuleStateName02){
        SC_THREAD(fsm);
    }
    int val;
    bool res;
    void fsm() {
        while (true) {
            m_in->master_read(val);
            m_out->master_write(val,"idle");

            m_in->master_read(val);
            m_out->master_write(val,"store");

        }
    }
};

SC_MODULE(ModuleStateName03) {
    master_in<int> m_in;
    slave_in<int> s_in;
    slave_out<int> s_out;
    master_out<int> m_out;

    SC_CTOR(ModuleStateName03){
        SC_THREAD(fsm);
    }
    int val;
    bool res;
    void fsm() {
        while (true) {
            insert_state("idle");
            s_in->slave_read(val,res);
            m_in->master_read(val);
            m_out->master_write(val,"idle");
            s_out->slave_write(val);

            insert_state();
            m_in->master_read(val);
            s_in->slave_read(val,res);
            m_out->master_write(val);
            s_out->slave_write(val);

        }
    }
};


#endif //DESCAM_MODULESTATENAMES_H
