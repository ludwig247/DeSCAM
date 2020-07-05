//
// Created by Tobias Jauch on 26.05.2020
//
#include "../../../Interfaces/Interfaces.h"
#include "systemc.h"
#include "DataTypes.h"



//#ifndef PROJECT_BUS_H
//#define PROJECT_BUS_H

#define ARRAY_DIM 2
#define ARRAY_SIZE 8


using namespace std;
using namespace sc_dt;


struct FFT : public sc_module {


    //Variables
    phases phase_algorithm;
    //sc_fix data_algorithm[ARRAY_DIM][ARRAY_SIZE];

    sc_fix real[ARRAY_SIZE];
    sc_fix img[ARRAY_SIZE];

    sc_fix real_bitmirror[ARRAY_SIZE];
    sc_fix img_bitmirror[ARRAY_SIZE];

    sc_fix real_twid[ARRAY_SIZE/2];
    sc_fix img_twid[ARRAY_SIZE/2];

    sc_fix typed;

    sc_fix twoPi = 6.28318530717959;

    int n; // counter for prep loop

    int i; //counter for outer loop
    int j; //counter for inner loop

    int span = ARRAY_SIZE>>1;
    int even;
    int odd = span;
    int log = 0;
    int rootindex;


    sc_fix temp;

    //data
    //blocking_in<sc_fix[ARRAY_DIM][ARRAY_SIZE]> data_in;
    //blocking_out<sc_fix[ARRAY_DIM][ARRAY_SIZE]> data_out;

    blocking_in<sc_fix[ARRAY_SIZE]> data_in_real;
    blocking_in<sc_fix[ARRAY_SIZE]> data_in_img;
    blocking_out<sc_fix[ARRAY_SIZE]> data_out_real;
    blocking_out<sc_fix[ARRAY_SIZE]> data_out_img;


    SC_HAS_PROCESS(FFT);

    FFT(sc_module_name name) :
            //data_in("data_in"),
            //data_out("data_out") {
            data_in_real("data_in_real"),
            data_in_img("data_in_img"),
            data_out_real("data_out_real"),
            data_out_img("data_out_img"){
        SC_THREAD(fsm);
    }

    void fsm() {

        phase_algorithm = IDLE;

        while (true) {

            if (phase_algorithm == IDLE) {

                //data_in->read(data_algorithm, "data_in");
                data_in_real->read(real, "data_in_real");
                data_in_img->read(img);
                phase_algorithm = PREP;
                n = 0;
                i = 0;

            }else if (phase_algorithm == PREP){

                if (n != ARRAY_SIZE>>1){
                    typed = (sc_fix)(twoPi*n/ARRAY_SIZE);
                    real_twid[n] = cos(typed);
                    img_twid[n] = (-1.0)*sin(typed);

                    cout << real_twid[n] << endl;
                    cout << img_twid[n] << endl;

                    ++n;

                    insert_state("prep");

                }else{
                    phase_algorithm = RUN;
                }

            }else if(phase_algorithm == RUN){
                if (span != 0) {
                    //cout << "Outer Loop: " << span << " ";

                    if (odd < ARRAY_SIZE) {
                        //cout << "Inner Loop: " << j << endl;

                        odd |= span;        // bitwise OR
                        even = odd ^ span;  // bitwise XOR

                        //cout << "odd: " << odd << endl;
                        //cout << "even: " << even << endl;

                        temp = real[even] + real[odd];
                        real[odd] = real[even] - real[odd];
                        real[even] = temp;

                        temp = img[even] + img[odd];
                        img[odd] = img[even] - img[odd];
                        img[even] = temp;

                        //cout << "log: " << log << endl;

                        rootindex = (even<<log) & (ARRAY_SIZE-1);
                        //cout << "Rootindex: " << rootindex << endl;

                        if(rootindex){
                            temp = real_twid[rootindex] * real[odd] - img_twid[rootindex] * img[odd];
                            img[odd] = real_twid[rootindex] * img[odd] + img_twid[rootindex] * real[odd];
                            real[odd] = temp;
                        }

                        ++odd;

                        insert_state("inner loop");

                        /*for (i = 0; i < ARRAY_SIZE ; ++i) {
                            cout << real[i] << " ";
                        }
                        cout << endl;

                        for (i = 0; i < ARRAY_SIZE ; ++i) {
                            cout << img[i] << " ";
                        }
                        cout << endl << endl;*/

                    } else {
                        span = span >> 1;
                        odd = span;
                        ++log;
                    }



                } else {

                    real_bitmirror[0] = real[0];
                    real_bitmirror[1] = real[4];
                    real_bitmirror[2] = real[2];
                    real_bitmirror[3] = real[6];
                    real_bitmirror[4] = real[1];
                    real_bitmirror[5] = real[5];
                    real_bitmirror[6] = real[3];
                    real_bitmirror[7] = real[7];

                    img_bitmirror[0] = img[0];
                    img_bitmirror[1] = img[4];
                    img_bitmirror[2] = img[2];
                    img_bitmirror[3] = img[6];
                    img_bitmirror[4] = img[1];
                    img_bitmirror[5] = img[5];
                    img_bitmirror[6] = img[3];
                    img_bitmirror[7] = img[7];

                    phase_algorithm = DATA_OUT;
                    i = 0;

                }

            }else{

                data_out_real->write(real_bitmirror, "data_out");
                data_out_img->write(img_bitmirror);
                phase_algorithm = IDLE;

            }

        }


    }


};
