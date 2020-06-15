//
// Created by Tobias Jauch on 26.05.2020
//
#include "../../Interfaces/Interfaces.h"
#include "systemc.h"
#include "DataTypes.h"


//#ifndef PROJECT_BUS_H
//#define PROJECT_BUS_H

#define ARRAY_SIZE 64

using namespace std;

struct BubbleSort : public sc_module {

    //Variables
    phases phase_algorithm;
    int data_algorithm[ARRAY_SIZE];

    int i; //counter for outer loop
    int j; //counter for inner loop
    int swap; //buffer for swapping values

    //data
    blocking_in<int[ARRAY_SIZE]> data_in;
    blocking_out<int[ARRAY_SIZE]> data_out;


    SC_HAS_PROCESS(BubbleSort);

    BubbleSort(sc_module_name name) :
       data_in("data_in"),
       data_out("data_out")
       {
        SC_THREAD(fsm);
       }

    void fsm() {

        phase_algorithm = IDLE;

        while (true) {

            if(phase_algorithm == IDLE) {

                data_in->read(data_algorithm,"data_in");
                phase_algorithm = RUN;
                i = 0;
                j = 0;

            }else{
                if (i != ARRAY_SIZE){
                    if (j != ARRAY_SIZE - i - 1){
                        if (data_algorithm[j] > data_algorithm[j+1]){

                            swap = data_algorithm[j];

                            data_algorithm[0] = j==0 ?  data_algorithm[1] : data_algorithm[0];
                            data_algorithm[1] = j==1 ?  data_algorithm[2] : data_algorithm[1];
                            data_algorithm[2] = j==2 ?  data_algorithm[3] : data_algorithm[2];
                            data_algorithm[3] = j==3 ?  data_algorithm[4] : data_algorithm[3];
                            data_algorithm[4] = j==4 ?  data_algorithm[5] : data_algorithm[4];
                            data_algorithm[5] = j==5 ?  data_algorithm[6] : data_algorithm[5];
                            data_algorithm[6] = j==6 ?  data_algorithm[7] : data_algorithm[6];
                            data_algorithm[7] = j==7 ?  data_algorithm[8] : data_algorithm[7];
                            data_algorithm[8] = j==8 ?  data_algorithm[9] : data_algorithm[8];
                            data_algorithm[9] = j==9 ?  data_algorithm[10] : data_algorithm[9];
                            data_algorithm[10] = j==10 ?  data_algorithm[11] : data_algorithm[10];
                            data_algorithm[11] = j==11 ?  data_algorithm[12] : data_algorithm[11];
                            data_algorithm[12] = j==12 ?  data_algorithm[13] : data_algorithm[12];
                            data_algorithm[13] = j==13 ?  data_algorithm[14] : data_algorithm[13];
                            data_algorithm[14] = j==14 ?  data_algorithm[15] : data_algorithm[14];
                            data_algorithm[15] = j==15 ?  data_algorithm[16] : data_algorithm[15];
                            data_algorithm[16] = j==16 ?  data_algorithm[17] : data_algorithm[16];
                            data_algorithm[17] = j==17 ?  data_algorithm[18] : data_algorithm[17];
                            data_algorithm[18] = j==18 ?  data_algorithm[19] : data_algorithm[18];
                            data_algorithm[19] = j==19 ?  data_algorithm[20] : data_algorithm[19];
                            data_algorithm[20] = j==20 ?  data_algorithm[21] : data_algorithm[20];
                            data_algorithm[21] = j==21 ?  data_algorithm[22] : data_algorithm[21];
                            data_algorithm[22] = j==22 ?  data_algorithm[23] : data_algorithm[22];
                            data_algorithm[23] = j==23 ?  data_algorithm[24] : data_algorithm[23];
                            data_algorithm[24] = j==24 ?  data_algorithm[25] : data_algorithm[24];
                            data_algorithm[25] = j==25 ?  data_algorithm[26] : data_algorithm[25];
                            data_algorithm[26] = j==26 ?  data_algorithm[27] : data_algorithm[26];
                            data_algorithm[27] = j==27 ?  data_algorithm[28] : data_algorithm[27];
                            data_algorithm[28] = j==28 ?  data_algorithm[29] : data_algorithm[28];
                            data_algorithm[29] = j==29 ?  data_algorithm[30] : data_algorithm[29];
                            data_algorithm[30] = j==30 ?  data_algorithm[31] : data_algorithm[30];
                            data_algorithm[31] = j==31 ?  data_algorithm[32] : data_algorithm[31];
                            data_algorithm[32] = j==32 ?  data_algorithm[33] : data_algorithm[32];
                            data_algorithm[33] = j==33 ?  data_algorithm[34] : data_algorithm[33];
                            data_algorithm[34] = j==34 ?  data_algorithm[35] : data_algorithm[34];
                            data_algorithm[35] = j==35 ?  data_algorithm[36] : data_algorithm[35];
                            data_algorithm[36] = j==36 ?  data_algorithm[37] : data_algorithm[36];
                            data_algorithm[37] = j==37 ?  data_algorithm[38] : data_algorithm[37];
                            data_algorithm[38] = j==38 ?  data_algorithm[39] : data_algorithm[38];
                            data_algorithm[39] = j==39 ?  data_algorithm[40] : data_algorithm[39];
                            data_algorithm[40] = j==40 ?  data_algorithm[41] : data_algorithm[40];
                            data_algorithm[41] = j==41 ?  data_algorithm[42] : data_algorithm[41];
                            data_algorithm[42] = j==42 ?  data_algorithm[43] : data_algorithm[42];
                            data_algorithm[43] = j==43 ?  data_algorithm[44] : data_algorithm[43];
                            data_algorithm[44] = j==44 ?  data_algorithm[45] : data_algorithm[44];
                            data_algorithm[45] = j==45 ?  data_algorithm[46] : data_algorithm[45];
                            data_algorithm[46] = j==46 ?  data_algorithm[47] : data_algorithm[46];
                            data_algorithm[47] = j==47 ?  data_algorithm[48] : data_algorithm[47];
                            data_algorithm[48] = j==48 ?  data_algorithm[49] : data_algorithm[48];
                            data_algorithm[49] = j==49 ?  data_algorithm[50] : data_algorithm[49];
                            data_algorithm[50] = j==50 ?  data_algorithm[51] : data_algorithm[50];
                            data_algorithm[51] = j==51 ?  data_algorithm[52] : data_algorithm[51];
                            data_algorithm[52] = j==52 ?  data_algorithm[53] : data_algorithm[52];
                            data_algorithm[53] = j==53 ?  data_algorithm[54] : data_algorithm[53];
                            data_algorithm[54] = j==54 ?  data_algorithm[55] : data_algorithm[54];
                            data_algorithm[55] = j==55 ?  data_algorithm[56] : data_algorithm[55];
                            data_algorithm[56] = j==56 ?  data_algorithm[57] : data_algorithm[56];
                            data_algorithm[57] = j==57 ?  data_algorithm[58] : data_algorithm[57];
                            data_algorithm[58] = j==58 ?  data_algorithm[59] : data_algorithm[58];
                            data_algorithm[59] = j==59 ?  data_algorithm[60] : data_algorithm[59];
                            data_algorithm[60] = j==60 ?  data_algorithm[61] : data_algorithm[60];
                            data_algorithm[61] = j==61 ?  data_algorithm[62] : data_algorithm[61];
                            data_algorithm[62] = j==62 ?  data_algorithm[63] : data_algorithm[62];

                            //cnt = 0;
                            data_algorithm[1] = j==0 ?  swap : data_algorithm[1];
                            //++cnt;
                            data_algorithm[2] = j==1 ?  swap : data_algorithm[2];
                            data_algorithm[3] = j==2 ?  swap : data_algorithm[3];
                            data_algorithm[4] = j==3 ?  swap : data_algorithm[4];
                            data_algorithm[5] = j==4 ?  swap : data_algorithm[5];
                            data_algorithm[6] = j==5 ?  swap : data_algorithm[6];
                            data_algorithm[7] = j==6 ?  swap : data_algorithm[7];
                            data_algorithm[8] = j==7 ?  swap : data_algorithm[8];
                            data_algorithm[9] = j==8 ?  swap : data_algorithm[9];
                            data_algorithm[10] = j==9 ?  swap : data_algorithm[10];
                            data_algorithm[11] = j==10 ?  swap : data_algorithm[11];
                            data_algorithm[12] = j==11 ?  swap : data_algorithm[12];
                            data_algorithm[13] = j==12 ?  swap : data_algorithm[13];
                            data_algorithm[14] = j==13 ?  swap : data_algorithm[14];
                            data_algorithm[15] = j==14 ?  swap : data_algorithm[15];
                            data_algorithm[16] = j==15 ?  swap : data_algorithm[16];
                            data_algorithm[17] = j==16 ?  swap : data_algorithm[17];
                            data_algorithm[18] = j==17 ?  swap : data_algorithm[18];
                            data_algorithm[19] = j==18 ?  swap : data_algorithm[19];
                            data_algorithm[20] = j==19 ?  swap : data_algorithm[20];
                            data_algorithm[21] = j==20 ?  swap : data_algorithm[21];
                            data_algorithm[22] = j==21 ?  swap : data_algorithm[22];
                            data_algorithm[23] = j==22 ?  swap : data_algorithm[23];
                            data_algorithm[24] = j==23 ?  swap : data_algorithm[24];
                            data_algorithm[25] = j==24 ?  swap : data_algorithm[25];
                            data_algorithm[26] = j==25 ?  swap : data_algorithm[26];
                            data_algorithm[27] = j==26 ?  swap : data_algorithm[27];
                            data_algorithm[28] = j==27 ?  swap : data_algorithm[28];
                            data_algorithm[29] = j==28 ?  swap : data_algorithm[29];
                            data_algorithm[30] = j==29 ?  swap : data_algorithm[30];
                            data_algorithm[31] = j==30 ?  swap : data_algorithm[31];
                            data_algorithm[32] = j==31 ?  swap : data_algorithm[32];
                            data_algorithm[33] = j==32 ?  swap : data_algorithm[33];
                            data_algorithm[34] = j==33 ?  swap : data_algorithm[34];
                            data_algorithm[35] = j==34 ?  swap : data_algorithm[35];
                            data_algorithm[36] = j==35 ?  swap : data_algorithm[36];
                            data_algorithm[37] = j==36 ?  swap : data_algorithm[37];
                            data_algorithm[38] = j==37 ?  swap : data_algorithm[38];
                            data_algorithm[39] = j==38 ?  swap : data_algorithm[39];
                            data_algorithm[40] = j==39 ?  swap : data_algorithm[40];
                            data_algorithm[41] = j==40 ?  swap : data_algorithm[41];
                            data_algorithm[42] = j==41 ?  swap : data_algorithm[42];
                            data_algorithm[43] = j==42 ?  swap : data_algorithm[43];
                            data_algorithm[44] = j==43 ?  swap : data_algorithm[44];
                            data_algorithm[45] = j==44 ?  swap : data_algorithm[45];
                            data_algorithm[46] = j==45 ?  swap : data_algorithm[46];
                            data_algorithm[47] = j==46 ?  swap : data_algorithm[47];
                            data_algorithm[48] = j==47 ?  swap : data_algorithm[48];
                            data_algorithm[49] = j==48 ?  swap : data_algorithm[49];
                            data_algorithm[50] = j==49 ?  swap : data_algorithm[50];
                            data_algorithm[51] = j==50 ?  swap : data_algorithm[51];
                            data_algorithm[52] = j==51 ?  swap : data_algorithm[52];
                            data_algorithm[53] = j==52 ?  swap : data_algorithm[53];
                            data_algorithm[54] = j==53 ?  swap : data_algorithm[54];
                            data_algorithm[55] = j==54 ?  swap : data_algorithm[55];
                            data_algorithm[56] = j==55 ?  swap : data_algorithm[56];
                            data_algorithm[57] = j==56 ?  swap : data_algorithm[57];
                            data_algorithm[58] = j==57 ?  swap : data_algorithm[58];
                            data_algorithm[59] = j==58 ?  swap : data_algorithm[59];
                            data_algorithm[60] = j==59 ?  swap : data_algorithm[60];
                            data_algorithm[61] = j==60 ?  swap : data_algorithm[61];
                            data_algorithm[62] = j==61 ?  swap : data_algorithm[62];
                            data_algorithm[63] = j==62 ?  swap : data_algorithm[63];

                        }
                        ++j;
                        //insert_state("inner_loop");
                    }else{
                        j = 0;
                        ++i;

                    }
                    insert_state("loop");

                }else{

                    data_out->write(data_algorithm, "data_out");

                    phase_algorithm = IDLE;

                }

            }

        }

    }

};


