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
        read, compute
    };
    Sections section;
    Sections nextsection;

    //In-port
//    sc_port<rendezvous_in_if<act_t> > bus_in;
    blocking_in<act_t>  bus_in;
    blocking_out<bool>  bus_resp;

    //Constructor
    SC_HAS_PROCESS(PID_Actuator);

    PID_Actuator(sc_module_name name) :
            section(read),
            nextsection(read),
            bus_in("bus_in"),
            bus_resp("bus_out"){
        SC_THREAD(fsm);
    }

    //Variables
    act_t param;
    int err;
    int prev_err;
    int integral;
    int derivative;

    //Represent sharded_outs
    bool device_power;
    int dac;

    void fsm() {
        while (true) {
            section = nextsection;
            if (section == read) {
                bus_in->read(param);
                bus_resp->write(0);
                //Shared.set
                device_power = param.on;
                if (param.on == true) {
                    nextsection = compute;
                }

            }
            if (section == compute) {
                err = param.setpoint - param.sample_value;
                integral = integral + err * param.sample_time;
                derivative = (err - prev_err) / param.sample_time;
                prev_err = err;
                //Shared.set
                dac = param.Kp * err + param.Ki * integral + param.Kd * derivative;
                nextsection = read;
            }
            wait(SC_ZERO_TIME);
        }
    }
};


#endif //PROJECT_PID_ACTUATOR_H
