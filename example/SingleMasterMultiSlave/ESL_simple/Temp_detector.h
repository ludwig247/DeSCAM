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
        MEASURE, UPDATE
    };
    Sections section;
    Sections nextsection;

    //In-port
    blocking_in<bool>  sample_event;
    //Out-por//    Shared<err_id_t> errReport("errReport");
//    uP.uP_report(errReport);
//    server.uP_report(errReport);t
    blocking_out<sensor_t> temp_out;

    //Constructor
    SC_HAS_PROCESS(Temp_detector);

    Temp_detector(sc_module_name name) :
            section(MEASURE),
            nextsection(MEASURE),
            sample_event("sample_event"),
            temp_out("temp_out"),
            MAX_DIFF(3){
        SC_THREAD(fsm);
    }

    //Variables
    sensor_t avg_temp = {0,false};
    int adc_value;
    int sample_cnt ;
    int sample_cnt_ok ;
    int measured_sum ;
    int measured_sum_ok ;
    int average_last ;
    bool sample_event_val;
    //Represent sharded_outs
    int adc_in;
    int dac;
    //Constant
    int MAX_DIFF;

    void fsm() {

        while (true) {
            section = nextsection;
            if (section == MEASURE) {
                sample_event->read(sample_event_val);
                adc_in = adc_value;
                measured_sum = measured_sum + adc_value;
                ++sample_cnt;
                if (abs(average_last - adc_value) <= MAX_DIFF) {
                    measured_sum_ok = measured_sum_ok + adc_value;
                    ++sample_cnt_ok;
                }
                if (sample_cnt == 16) {
                    nextsection = UPDATE;
                }
            }
            if (section == UPDATE) {
                average_last = measured_sum / 16;
                avg_temp.stable = (sample_cnt_ok >= 10);
                if (avg_temp.stable == true) {
                    avg_temp.data = measured_sum_ok / sample_cnt_ok;
                }
                temp_out->write(avg_temp);
                sample_cnt = 0;
                measured_sum = 0;
                sample_cnt_ok = 0;
                measured_sum_ok = 0;
                nextsection = MEASURE;

            }
            wait(SC_ZERO_TIME);
        }
    }


};


#endif //PROJECT_TEMP_DETECTOR_H
