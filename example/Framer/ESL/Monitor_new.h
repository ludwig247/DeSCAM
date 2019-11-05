//
// Created by ludwig on 29.08.17.
//

#ifndef PROJECT_MONITOR_UPDATE_H_H
#define PROJECT_MONITOR_UPDATE_H_H


#include "systemc.h"
#include "../../Interfaces_new/Interfaces.h"

//FIXME: ALL created types need to be put in a separate file (like FPI example)
struct Config {
    int LOFset;
    int LOFreset;
};

struct Monitor_new : public sc_module {
    //
    enum Phases {
        Monitor_LOF, Monitor_N_LOF
    };

    Phases phase;
    Phases nextphase;


    //Constructor
    SC_HAS_PROCESS(Monitor_new);

    Monitor_new(sc_module_name name) :
            frame_pulse("frame_pulse"),
            oof("oof"),
            lof("lof"),
            cnt(0),
            oof_var(false),
            LOFreset(8),
            LOFset(8) {
        SC_THREAD(fsm);
    }

    //Vars
    bool oof_var;
    int cnt;
    Config config;
    int LOFreset;
    int LOFset;
    bool tmp;
    //In-port
    slave_in<bool> frame_pulse;
    shared_in<Config> config_in;
    shared_in<bool> oof;
    //Output
    shared_out<bool> lof;

    void fsm() {
        nextphase = Monitor_N_LOF;
        while (true) {
            phase = nextphase;
            if (phase == Monitor_LOF) {
                wait(WAIT_TIME, SC_PS);//state
                frame_pulse->slave_read(tmp, tmp);
                config_in->get(config);
                if (tmp) {
                    oof->get(oof_var);
                    if (oof_var) {
                        cnt = 0;
                        lof->set(true);
                    } else {
                        if (cnt < config.LOFreset) {
                            ++cnt;
                            lof->set(true);
                        } else {
                            cnt = 0;
                            lof->set(false);
                            nextphase = Monitor_N_LOF;
                        }
                    }
                }
            }
            if (phase == Monitor_N_LOF) {
                wait(WAIT_TIME, SC_PS);//state
                frame_pulse->slave_read(tmp, tmp);
                config_in->get(config);
                if (tmp) {
                    oof->get(oof_var);
                    if (oof_var) {
                        if (cnt < config.LOFset) {
                            ++cnt;
                            lof->set(false);
                        } else {
                            nextphase = Monitor_LOF;
                            lof->set(true);
                            cnt = 0;
                        }
                    } else {
                        cnt = 0;
                        lof->set(false);
                    }
                }

            }
            //wait(SC_ZERO_TIME);
        }
    }

};

#endif //PROJECT_MONITOR_UPDATE_H_H
