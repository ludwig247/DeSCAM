//
// Created by tobias on 27.01.17.
//

#ifndef PROJECT_UPROCESSOR_H
#define PROJECT_UPROCESSOR_H

#include "systemc.h"
#include "../../Interfaces/Interfaces.h"
#include "Compound.h"


struct uProcessor : public sc_module {
public:
    //Sections
    enum Sections {
        CONFIG, ERROR
    };
    Sections section;
    Sections nextsection;

    //Out-port
    shared_in<err_id_t>  uP_report_in;
    //In-port
    shared_out<config_t> uP_out;

    //Constructor
    SC_HAS_PROCESS(uProcessor);

    uProcessor(sc_module_name name) :
            section(CONFIG),
            nextsection(CONFIG),
            uP_out("uP_out"),
            uP_report_in("uP_report_in"),
            error(NO_ERR){
        SC_THREAD(fsm);
    }

    config_t config;
    err_id_t error;

    void fsm() {
        while (true) {
            section = nextsection;
            if (section == CONFIG) {
                config.Kp_Heat = 1;
                config.Kd_Heat = 2;
                config.Ki_Heat = 3;

                config.Kp_Mix = 4;
                config.Kd_Mix = 5;
                config.Ki_Mix = 6;

                config.max_temp_diff = 7;

                config.sample_time = 8;
                config.target_temp = 24;
                uP_out->set(config);
                uP_report_in->get(error);
                nextsection = ERROR;
            }
            if (section == ERROR) {
                uP_report_in->get(error);
                if (error != NO_ERR) {
                    sc_stop();
                }
            }
            if (sc_delta_count() > 50) sc_stop();
            wait(SC_ZERO_TIME);
        }
    }
};


#endif //PROJECT_UPROCESSOR_H
