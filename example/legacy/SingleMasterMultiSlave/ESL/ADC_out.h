//
// Created by tobias on 03.02.17.
//

#ifndef PROJECT_ADC_H
#define PROJECT_ADC_H
#include "systemc.h"
#include "../../Interfaces/Interfaces.h"
#include "Compound.h"

struct ADC_out : public sc_module {
public:
    //Out-port
    shared_out <int> adc_val;

    //Constructor
    SC_HAS_PROCESS(ADC_out);
    ADC_out(sc_module_name name)
    {
        SC_THREAD(fsm);
    };
    bool fluctuate;
    int val;

    void fsm() {
        while (true) {
            val = std::rand()%5;
            fluctuate = std::rand()%2;

            if(fluctuate == false){
                adc_val->set(20+val);
            }else{
                adc_val->set(20-val);
            }
            wait(SC_ZERO_TIME);
        }
    }
};

#endif //PROJECT_ADC_H
