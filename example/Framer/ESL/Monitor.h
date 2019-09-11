//
// Created by ludwig on 29.08.17.
//

#ifndef PROJECT_MONITOR_UPDATE_H_H
#define PROJECT_MONITOR_UPDATE_H_H


#include "systemc.h"
#include "../../Interfaces/Interfaces.h"

//FIXME: ALL created types need to be put in a separate file (like FPI example)
struct Config {
    int LOFset;
    int LOFreset;
};

struct Monitor : public sc_module {
    //
    enum Sections {
        LOF, N_LOF
    };

    Sections section;
    Sections nextsection;


    //Constructor
    SC_HAS_PROCESS(Monitor);

    Monitor(sc_module_name name) :
            frame_pulse("frame_pulse"),
            oof("oof"),
            lof("lof"),
            cnt(0),
            oof_var(false),
            LOFreset(8),
            LOFset(8),
            section(N_LOF),
            nextsection(N_LOF) {
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
        while (true) {
            section = nextsection;
            if (section == LOF) {
                tmp = frame_pulse->nb_read(tmp);
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
                            nextsection = N_LOF;
                        }
                    }
                }
            }
            if (section == N_LOF) {
                tmp = frame_pulse->nb_read(tmp);
                config_in->get(config);
                if (tmp) {
                    oof->get(oof_var);
                    if (oof_var) {
                        if (cnt < config.LOFset) {
                            ++cnt;
                            lof->set(false);
                        } else {
                            nextsection = LOF;
                            lof->set(true);
                            cnt = 0;
                        }
                    } else {
                        cnt = 0;
                        lof->set(false);
                    }
                }

            }
            wait(SC_ZERO_TIME);
        }
    }

};

#endif //PROJECT_MONITOR_UPDATE_H_H
