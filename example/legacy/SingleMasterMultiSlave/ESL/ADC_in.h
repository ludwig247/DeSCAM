//
// Created by tobias on 03.02.17.
//

#ifndef PROJECT_ADC_IN_H
#define PROJECT_ADC_IN_H

#include "systemc.h"
#include "../../Interfaces/Interfaces.h"
#include "Compound.h"

struct ADC_in : public sc_module {
public:
    //Out-port
    shared_in <int> adc_val;

    //Constructor
    SC_HAS_PROCESS(ADC_in);
    ADC_in(sc_module_name name)
    {
        SC_THREAD(fsm);
    };
    int val;
    void fsm() {

        while (true) {
            adc_val->get(val);
            wait(SC_ZERO_TIME);
        }
    }
};



#endif //PROJECT_ADC_IN_H
