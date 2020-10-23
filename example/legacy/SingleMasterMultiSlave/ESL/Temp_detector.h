//
// Created by ludwig on 18.01.17.
//

#ifndef PROJECT_TEMP_DETECTOR_H
#define PROJECT_TEMP_DETECTOR_H

#include "systemc.h"
#include "../../Interfaces/Interfaces.h"
#include "Compound.h"


struct Temp_detector : public sc_module {
    //Sections
    enum Sections {
        MEASURE, CHECK, UPDATE
    };
    Sections section;
    Sections nextsection;

    //In-port
    blocking_in<bool> sample_event;
    shared_in<int> adc_in;
    //Out-por
    shared_out<int> temp_out;


    //Constructor
    SC_HAS_PROCESS(Temp_detector);

    Temp_detector(sc_module_name name) :
            section(UPDATE),
            nextsection(UPDATE),
            sample_event("sample_event"),
            temp_out("temp_out"),
            adc_in("adc_in"),
            avg_temp_last(20),
            sample_cnt_ok(16),
            measured_sum_ok(320) {
        SC_THREAD(fsm);
    }

    //Variables
    int avg_temp;
    int adc_value;
    int sample_cnt;
    int sample_cnt_ok;
    int measured_sum_ok;
    int avg_temp_last;
    bool tmp;

    //Represent sharded_outs
    //Constant

    void fsm() {

        while (true) {
            section = nextsection;
            if (section == MEASURE) {
//                std::cout << this->name() << " - measure" << std::endl;
                sample_event->read(tmp);
                nextsection = CHECK;
            }
            if (section == CHECK) {
//                std::cout << this->name() << " - check" << std::endl;
                adc_in->get(adc_value);
                ++sample_cnt;
                if (adc_value > 0 && adc_value < 40 && (avg_temp_last - adc_value < max_diff) && (adc_value - avg_temp_last < max_diff)) {
                    ++sample_cnt_ok;
                    measured_sum_ok = measured_sum_ok + adc_value;
                }

            if (sample_cnt == 16) {
                nextsection = UPDATE;
            } else {
                nextsection = MEASURE;
            }
        }
        if (section == UPDATE) {
//            std::cout << this->name() << " - update " << std::endl;
            if (sample_cnt_ok > 10) {
                avg_temp = measured_sum_ok / sample_cnt_ok;
                avg_temp_last = avg_temp;
            } else {
                avg_temp = avg_temp_last;
            }
            sample_cnt = 0;
            sample_cnt_ok = 0;
            measured_sum_ok = 0;
            temp_out->set(avg_temp);



            nextsection = MEASURE;
        }
        wait(SC_ZERO_TIME);
    }
}


};


#endif //PROJECT_TEMP_DETECTOR_H
