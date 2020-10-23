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
    blocking_in<err_id_t>  uP_report_in;
    //In-port
    blocking_out<config_t> uP_out;


    //Constructor
    SC_HAS_PROCESS(uProcessor);

    uProcessor(sc_module_name name) :
            section(CONFIG),
            nextsection(CONFIG),
            uP_out("uP_out"),
            uP_report_in("uP_report_in"),
            err(NO_ERR){
        SC_THREAD(fsm);
    }

    config_t config;
    err_id_t err;

    void fsm() {
        while (true) {
            section = nextsection;
            if (section == CONFIG) {
                //std::cout << this->name() <<  "-config" << std::endl;
                config.Kp_Heat = 1;
                config.Kd_Heat = 0;
                config.Ki_Heat = 0;

                config.Kp_Mix = 1;
                config.Kd_Mix = 0;
                config.Ki_Mix = 0;

                config.max_temp_diff = 10;

                config.sample_time = 10;
                config.target_temp = 20;
                uP_out->write(config);
                uP_report_in->read(err);
                nextsection = ERROR;
            }
            if (section == ERROR) {
                //std::cout << this->name() <<  "-ERROR" << std::endl;
                uP_report_in->read(err);
                if (err != NO_ERR) {
                    std::cout << "ERROR - stop " << std::endl;
                    sc_stop();
                }
            }
//            if (sc_delta_count() > 1000) sc_stop();
            wait(SC_ZERO_TIME);
        }
    }
};


#endif //PROJECT_UPROCESSOR_H
