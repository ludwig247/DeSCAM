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
        INIT, IDLE, CONFIG, GET_TEMP, SET_MIX, SET_HEAT, ERROR
    };

    Sections section;
    Sections nextsection;

    //Constructor
    SC_HAS_PROCESS(Server);

    Server(sc_module_name name) :
            bus_out("bus_out"),
            bus_in("bus_in"),
            uP_report_out("uP_report_out"),
            uP_in("uP_in"),
            heat_power("heat_power"),
            mix_power("mix_power"),
            sample_timer("sample_timer"),
            section(INIT),
            nextsection(INIT),
            err_id(NO_ERR){
        SC_THREAD(fsm);
    }

    //In-port
    blocking_out<bus_req_t> bus_out;
    blocking_in<bus_resp_t> bus_in;

    blocking_in<bool> sample_timer;

    //Those are all supposed to be shared? not?
    //Shared vars
    blocking_in<config_t> uP_in;
    blocking_out<err_id_t> uP_report_out;
    shared_out<bool> heat_power;
    shared_out<bool> mix_power;

    //Variables
    config_t uP;
    sensor_t temp_top;
    sensor_t temp_bot;
    act_t heat;
    act_t mix;
    err_id_t err_id;


    bus_req_t req;
    bus_resp_t resp;
    bus_resp_t resp_top;
    bus_resp_t resp_bot;

    bool nb_result;
    bool tmp;
    void fsm() {

        while (true) {

            section = nextsection;
            if (section == INIT) {
                //std::cout << this->name() <<  "-init" << std::endl;
                heat_power->set(true);
                mix_power->set(true);
                uP_in->read(uP);
                req.trans_type = SINGLE_WRITE;
                req.addr = 1;
                req.data = uP.sample_time;
                nextsection = CONFIG;
            }
            if (section == IDLE) {
                //std::cout << this->name() <<  "-idle" << std::endl;
                sample_timer->read(tmp);

                //if(uP_in->get(uP)) ?
                nb_result = uP_in->nb_read(uP);
                if (nb_result == true) {
                    req.trans_type = SINGLE_WRITE;
                    req.addr = 1;
                    req.data = uP.sample_time;
                    nextsection = CONFIG;
                } else {
                    nextsection = GET_TEMP;
                }
            }
            if (section == GET_TEMP) {
                //std::cout << this->name() <<  "-get_temp" << std::endl;
                req.trans_type = SINGLE_READ;
                req.addr = 16;
                bus_out->write(req);
                bus_in->read(resp_top);
                req.addr = 24;
                bus_out->write(req);
                bus_in->read(resp_bot);
                if (resp_top.ack != OK || resp_bot.ack != OK ||
                        resp_top.data > max_temp || resp_top.data < min_temp ||
                        resp_bot.data > max_temp || resp_bot.data < min_temp) {
                    err_id = ERR_TEMP;
                    nextsection = ERROR;
                } else {
                    if ((resp_top.data - resp_bot.data > uP.max_temp_diff) or (resp_bot.data - resp_top.data > uP.max_temp_diff)) {
                        err_id = ERR_MIX;
                        nextsection = ERROR;
                    } else {
                        nextsection = SET_MIX;
                    }
                }
            }
            if (section == SET_MIX) {
                //std::cout << this->name() <<  "-set_mix" << std::endl;
                req.trans_type = SINGLE_WRITE;
                req.addr = 8;
                req.data = (resp_top.data + resp_bot.data) / 2;
                bus_out->write(req);
                bus_in->read(resp);
                nextsection = SET_HEAT;
            }
            if (section == SET_HEAT) {
                //std::cout << this->name() <<  "-set_heat" << std::endl;
                req.trans_type = SINGLE_WRITE;
                req.addr = 0;
                req.data = (resp_top.data + resp_bot.data) / 2;
                bus_out->write(req);
                bus_in->read(resp);
                nextsection = IDLE;

            }
            if (section == ERROR) {
                //std::cout << this->name() <<  "-error" << std::endl;
                heat_power->set(false);
                mix_power->set(false);
                uP_report_out->write(err_id);
            }
            if (section == CONFIG) {
                //std::cout << this->name() <<  "-config" << std::endl;
                bus_out->write(req);
                bus_in->read(resp);

                if (req.addr == 1) {
                    req.addr = 2;
                    req.data = uP.target_temp;

                } else if (req.addr == 2) {
                    req.addr = 3;
                    req.data = uP.Kp_Heat;
                } else if (req.addr == 3) {
                    req.addr = 4;
                    req.data = uP.Ki_Heat;
                } else if (req.addr == 4) {
                    req.addr = 5;
                    req.data = uP.Kd_Heat;
                } else if (req.addr == 5) {
                    req.addr = 9;
            }
                    req.data = uP.sample_time;
                } else if (req.addr == 9) {
                    req.addr = 10;
                    req.data = uP.target_temp;
                } else if (req.addr == 10) {
                    req.addr = 11;
                    req.data = uP.Kp_Mix;
                } else if (req.addr == 11) {
                    req.addr = 12;
                    req.data = uP.Ki_Mix;
                } else if (req.addr == 12) {
                    req.addr = 13;
                    req.data = uP.Kd_Mix;
                } else {
                    nextsection = GET_TEMP;
                }


            wait(SC_ZERO_TIME);
        }

    }


};


#endif //SCAM_SERVER_H
