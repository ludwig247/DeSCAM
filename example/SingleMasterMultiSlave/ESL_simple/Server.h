//
// Created by ludwig on 08.12.16.
//

#ifndef SCAM_SERVER_H
#define SCAM_SERVER_H

#include "systemc.h"
#include "../../Interfaces/Interfaces.h"
#include "Compound.h"

class Server : sc_module {
public:
    enum Sections {
        IDLE, GET_TEMP, MIXING, HEAT, ERROR
    };

    Sections section;
    Sections nextsection;


    //Constructor
    SC_HAS_PROCESS(Server);

    Server(sc_module_name name) :
            temp_top_in("temp_top_in"),
            temp_bot_in("temp_bot_in"),
            heat_resp("heat_resp"),
            mix_resp("mix_resp"),
            timer_dt("timer_dt"),
            heat_out("heat_out"),
            mix_out("mix_out"),
            uP_in("uP_in"),
            uP_report_out("uP_report_out"),
            section(IDLE),
            nextsection(IDLE),
            err_id(NO_ERR) {
        SC_THREAD(fsm);
    }

    //In-port
    blocking_in<sensor_t>  temp_top_in;
    blocking_in<sensor_t>  temp_bot_in;
    blocking_in<bool>  timer_dt;
    blocking_in<bool>  heat_resp;
    blocking_in<bool>  mix_resp;
    //Out-port
    blocking_out<act_t> heat_out;
    blocking_out<act_t> mix_out;

    //Shared vars
    shared_in<config_t>  uP_in;
    shared_out<err_id_t>  uP_report_out;

    //Variables
    config_t uP;
    sensor_t temp_top;
    sensor_t temp_bot;
    act_t heat;
    act_t mix;
    err_id_t err_id;
    bool timer_dt_ready;
    bool resp;


    void fsm() {
        while (true) {
            section = nextsection;
            if (section == IDLE) {
                timer_dt->read(timer_dt_ready);
                //Access to shared var
                uP_in->get(uP);
                nextsection = GET_TEMP;
            }
            if (section == GET_TEMP) {
                temp_top_in->read(temp_top);
                temp_bot_in->read(temp_bot);

                if (temp_top.stable == false) {
                    nextsection = ERROR;
                    err_id = ERR_TEMP_TOP;
                } else {
                    if (temp_bot.stable == false) {
                        nextsection = ERROR;
                        err_id = ERR_TEMP_BOT;
                    } else {
//                        if (abs(temp_top.data - temp_bot.data) > uP.max_temp_diff) {
                        if ((temp_top.data - temp_bot.data) > uP.max_temp_diff) {
                            //mixing is not working
                            nextsection = ERROR;
                            err_id = ERR_MIX;
                        } else {
                            nextsection = MIXING;
                        }
                    }
                }
            }
            if (section == MIXING) {
                mix.on = true;
//                mix.sample_value = abs(temp_top.data - temp_bot.data);
                mix.sample_value = (temp_top.data - temp_bot.data);
                mix.setpoint = 0;
                mix.Kp = uP.Kp_Mix;
                mix.Ki = uP.Ki_Mix;
                mix.Kd = uP.Kd_Mix;
                mix.sample_time = uP.sample_time;
                mix_out->write(mix);
                mix_resp->read(resp);

                nextsection = HEAT;

            }
            if (section == HEAT) {
                heat.on = true;
                heat.sample_value = (temp_top.data + temp_bot.data) / 2;
                heat.setpoint = uP.target_temp;
                heat.Kp = uP.Kp_Heat;
                heat.Ki = uP.Ki_Heat;
                heat.Kd = uP.Kd_Heat;
                heat.sample_time = uP.sample_time;
                heat_out->write(heat);
                heat_resp->read(resp);

                nextsection = GET_TEMP;

            }
            if (section == ERROR) {
                heat.on = false;
                mix.on = false;
                heat_out->write(heat);
                mix_out->write(mix);
                uP_report_out->set(err_id);
            }
            wait(SC_ZERO_TIME);
        }

    }


private:


};


#endif //SCAM_SERVER_H
