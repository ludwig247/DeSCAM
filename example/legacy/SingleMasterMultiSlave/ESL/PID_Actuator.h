//
// Created by ludwig on 18.01.17.findInitalValues.getVariableInitialMap().at(variable.first))
//


#ifndef PROJECT_PID_ACTUATOR_H
#define PROJECT_PID_ACTUATOR_H

#include "systemc.h"
#include "Compound.h"
#include "../../Interfaces/Interfaces.h"


struct PID_Actuator : public sc_module {
    //Sections
    enum Sections {
        reading, compute, checking
    };
    Sections section;
    Sections nextsection;

    //In-port
    blocking_in<bus_req_t> bus_req;
    blocking_out<bus_resp_t> bus_resp;
    shared_in<bool> power;
    //Out-port
    shared_out<int> dac;

    //Constructor
    SC_HAS_PROCESS(PID_Actuator);

    PID_Actuator(sc_module_name name) :
            section(reading),
            nextsection(reading),
            bus_req("bus_req"),
            bus_resp("bus_resp"),
            power("power"),
            setpoint(20),
            sample(20),
            sample_time(10),
            Kp(1),
            Ki(1),
            Kd(1),
            setup_correct(true),
            dac("dac") {
        SC_THREAD(fsm);
    }

    //Variables
    bus_req_t req;
    bus_resp_t resp;
    int sample_time;
    int setpoint;
    int Kp;
    int Ki;
    int Kd;
    int sample;
    int error;
    int prev_err;
    int integral;
    int deriv;
    bool device_power;
    bool setup_correct;

    void fsm() {
        while (true) {
            /*
             *   0 = sample_value
                 1 = sample_time
                 2 = setpoint
                 3 = Kp
                 4 = Ki
                 5 = Kd
                 6,7 = UNUSED

             */
            section = nextsection;
            if (section == reading) {
//                std::cout << this->name() << "-read" << std::endl;
                bus_req->read(req);
                resp.ack = OK;
                if (req.addr == 0) {
                    sample = req.data;

                } else if (req.addr == 1) {
                    sample_time = req.data;

                } else if (req.addr == 2) {
                    setpoint = req.data;

                } else if (req.addr == 3) {
                    Kp = req.data;

                } else if (req.addr == 4) {
                    Ki = req.data;

                } else if (req.addr == 5) {
                    Kd = req.data;
                } else {
                    //should be unreachable in this system
                    resp.ack = ERR;
                }
                bus_resp->write(resp);
                nextsection = checking;
            }

            if (section == checking) {
                this->power->get(device_power);

                setup_correct = setup_correct && (sample_time > sample_time_low) && (sample_time < sample_time_up) ;
                setup_correct = setup_correct && Kp >= Kp_low && Kp <= Kp_up;
                setup_correct = setup_correct && Ki >= Ki_low && Ki <= Ki_up;
                setup_correct = setup_correct && Kd >= Kd_low && Kd <= Kd_up;
                setup_correct = setup_correct && setpoint > setpoint_low && setpoint < setpoint_up;
                setup_correct = setup_correct && (setpoint - sample < max_diff && sample - setpoint < max_diff);

                //Only change output if device is switched on & is well configured
                if(device_power == true && setup_correct == true){
                    nextsection = compute;
                }else {
                    dac->set(0);
                    nextsection = reading;
                    sc_stop();
                }
            }
            if (section == compute) {
//                std::cout << this->name() << "-compute: sample" << std::endl;
                error = setpoint - sample;
                integral = integral + error * sample_time;
                if(integral > 65535) integral = 65535;
                if(integral < (0-65535)) integral = 0-65535;
                deriv = (error - prev_err) / sample_time;
                prev_err = error;
                dac->set(Kp * error + Ki * integral + Kd * deriv);
                //std::cout << this->name() << " output: " << Kp * error + Ki * integral + Kd * deriv << std::endl;
                nextsection = reading;
            }
            wait(SC_ZERO_TIME);
        }
    }
};


#endif //PROJECT_PID_ACTUATOR_H
