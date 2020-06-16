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
                            data_algorithm[63] = j==63 ?  data_algorithm[64] : data_algorithm[63];
                            data_algorithm[64] = j==64 ?  data_algorithm[65] : data_algorithm[64];
                            data_algorithm[65] = j==65 ?  data_algorithm[66] : data_algorithm[65];
                            data_algorithm[66] = j==66 ?  data_algorithm[67] : data_algorithm[66];
                            data_algorithm[67] = j==67 ?  data_algorithm[68] : data_algorithm[67];
                            data_algorithm[68] = j==68 ?  data_algorithm[69] : data_algorithm[68];
                            data_algorithm[69] = j==69 ?  data_algorithm[70] : data_algorithm[69];
                            data_algorithm[70] = j==70 ?  data_algorithm[71] : data_algorithm[70];
                            data_algorithm[71] = j==71 ?  data_algorithm[72] : data_algorithm[71];
                            data_algorithm[72] = j==72 ?  data_algorithm[73] : data_algorithm[72];
                            data_algorithm[73] = j==73 ?  data_algorithm[74] : data_algorithm[73];
                            data_algorithm[74] = j==74 ?  data_algorithm[75] : data_algorithm[74];
                            data_algorithm[75] = j==75 ?  data_algorithm[76] : data_algorithm[75];
                            data_algorithm[76] = j==76 ?  data_algorithm[77] : data_algorithm[76];
                            data_algorithm[77] = j==77 ?  data_algorithm[78] : data_algorithm[77];
                            data_algorithm[78] = j==78 ?  data_algorithm[79] : data_algorithm[78];
                            data_algorithm[79] = j==79 ?  data_algorithm[80] : data_algorithm[79];
                            data_algorithm[80] = j==80 ?  data_algorithm[81] : data_algorithm[80];
                            data_algorithm[81] = j==81 ?  data_algorithm[82] : data_algorithm[81];
                            data_algorithm[82] = j==82 ?  data_algorithm[83] : data_algorithm[82];
                            data_algorithm[83] = j==83 ?  data_algorithm[84] : data_algorithm[83];
                            data_algorithm[84] = j==84 ?  data_algorithm[85] : data_algorithm[84];
                            data_algorithm[85] = j==85 ?  data_algorithm[86] : data_algorithm[85];
                            data_algorithm[86] = j==86 ?  data_algorithm[87] : data_algorithm[86];
                            data_algorithm[87] = j==87 ?  data_algorithm[88] : data_algorithm[87];
                            data_algorithm[88] = j==88 ?  data_algorithm[89] : data_algorithm[88];
                            data_algorithm[89] = j==89 ?  data_algorithm[90] : data_algorithm[89];
                            data_algorithm[90] = j==90 ?  data_algorithm[91] : data_algorithm[90];
                            data_algorithm[91] = j==91 ?  data_algorithm[92] : data_algorithm[91];
                            data_algorithm[92] = j==92 ?  data_algorithm[93] : data_algorithm[92];
                            data_algorithm[93] = j==93 ?  data_algorithm[94] : data_algorithm[93];
                            data_algorithm[94] = j==94 ?  data_algorithm[95] : data_algorithm[94];
                            data_algorithm[95] = j==95 ?  data_algorithm[96] : data_algorithm[95];
                            data_algorithm[96] = j==96 ?  data_algorithm[97] : data_algorithm[96];
                            data_algorithm[97] = j==97 ?  data_algorithm[98] : data_algorithm[97];
                            data_algorithm[98] = j==98 ?  data_algorithm[99] : data_algorithm[98];
                            data_algorithm[99] = j==99 ?  data_algorithm[100] : data_algorithm[99];
                            data_algorithm[100] = j==100 ?  data_algorithm[101] : data_algorithm[100];
                            data_algorithm[101] = j==101 ?  data_algorithm[102] : data_algorithm[101];
                            data_algorithm[102] = j==102 ?  data_algorithm[103] : data_algorithm[102];
                            data_algorithm[103] = j==103 ?  data_algorithm[104] : data_algorithm[103];
                            data_algorithm[104] = j==104 ?  data_algorithm[105] : data_algorithm[104];
                            data_algorithm[105] = j==105 ?  data_algorithm[106] : data_algorithm[105];
                            data_algorithm[106] = j==106 ?  data_algorithm[107] : data_algorithm[106];
                            data_algorithm[107] = j==107 ?  data_algorithm[108] : data_algorithm[107];
                            data_algorithm[108] = j==108 ?  data_algorithm[109] : data_algorithm[108];
                            data_algorithm[109] = j==109 ?  data_algorithm[110] : data_algorithm[109];
                            data_algorithm[110] = j==110 ?  data_algorithm[111] : data_algorithm[110];
                            data_algorithm[111] = j==111 ?  data_algorithm[112] : data_algorithm[111];
                            data_algorithm[112] = j==112 ?  data_algorithm[113] : data_algorithm[112];
                            data_algorithm[113] = j==113 ?  data_algorithm[114] : data_algorithm[113];
                            data_algorithm[114] = j==114 ?  data_algorithm[115] : data_algorithm[114];
                            data_algorithm[115] = j==115 ?  data_algorithm[116] : data_algorithm[115];
                            data_algorithm[116] = j==116 ?  data_algorithm[117] : data_algorithm[116];
                            data_algorithm[117] = j==117 ?  data_algorithm[118] : data_algorithm[117];
                            data_algorithm[118] = j==118 ?  data_algorithm[119] : data_algorithm[118];
                            data_algorithm[119] = j==119 ?  data_algorithm[120] : data_algorithm[119];
                            data_algorithm[120] = j==120 ?  data_algorithm[121] : data_algorithm[120];
                            data_algorithm[121] = j==121 ?  data_algorithm[122] : data_algorithm[121];
                            data_algorithm[122] = j==122 ?  data_algorithm[123] : data_algorithm[122];
                            data_algorithm[123] = j==123 ?  data_algorithm[124] : data_algorithm[123];
                            data_algorithm[124] = j==124 ?  data_algorithm[125] : data_algorithm[124];
                            data_algorithm[125] = j==125 ?  data_algorithm[126] : data_algorithm[125];
                            data_algorithm[126] = j==126 ?  data_algorithm[127] : data_algorithm[126];


                            data_algorithm[1] = j==0 ?  swap : data_algorithm[1];
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
                            data_algorithm[64] = j==63 ?  swap : data_algorithm[64];
                            data_algorithm[65] = j==64 ?  swap : data_algorithm[65];
                            data_algorithm[66] = j==65 ?  swap : data_algorithm[66];
                            data_algorithm[67] = j==66 ?  swap : data_algorithm[67];
                            data_algorithm[68] = j==67 ?  swap : data_algorithm[68];
                            data_algorithm[69] = j==68 ?  swap : data_algorithm[69];
                            data_algorithm[70] = j==69 ?  swap : data_algorithm[70];
                            data_algorithm[71] = j==70 ?  swap : data_algorithm[71];
                            data_algorithm[72] = j==71 ?  swap : data_algorithm[72];
                            data_algorithm[73] = j==72 ?  swap : data_algorithm[73];
                            data_algorithm[74] = j==73 ?  swap : data_algorithm[74];
                            data_algorithm[75] = j==74 ?  swap : data_algorithm[75];
                            data_algorithm[76] = j==75 ?  swap : data_algorithm[76];
                            data_algorithm[77] = j==76 ?  swap : data_algorithm[77];
                            data_algorithm[78] = j==77 ?  swap : data_algorithm[78];
                            data_algorithm[79] = j==78 ?  swap : data_algorithm[79];
                            data_algorithm[80] = j==79 ?  swap : data_algorithm[80];
                            data_algorithm[81] = j==80 ?  swap : data_algorithm[81];
                            data_algorithm[82] = j==81 ?  swap : data_algorithm[82];
                            data_algorithm[83] = j==82 ?  swap : data_algorithm[83];
                            data_algorithm[84] = j==83 ?  swap : data_algorithm[84];
                            data_algorithm[85] = j==84 ?  swap : data_algorithm[85];
                            data_algorithm[86] = j==85 ?  swap : data_algorithm[86];
                            data_algorithm[87] = j==86 ?  swap : data_algorithm[87];
                            data_algorithm[88] = j==87 ?  swap : data_algorithm[88];
                            data_algorithm[89] = j==88 ?  swap : data_algorithm[89];
                            data_algorithm[90] = j==89 ?  swap : data_algorithm[90];
                            data_algorithm[91] = j==90 ?  swap : data_algorithm[91];
                            data_algorithm[92] = j==91 ?  swap : data_algorithm[92];
                            data_algorithm[93] = j==92 ?  swap : data_algorithm[93];
                            data_algorithm[94] = j==93 ?  swap : data_algorithm[94];
                            data_algorithm[95] = j==94 ?  swap : data_algorithm[95];
                            data_algorithm[96] = j==95 ?  swap : data_algorithm[96];
                            data_algorithm[97] = j==96 ?  swap : data_algorithm[97];
                            data_algorithm[98] = j==97 ?  swap : data_algorithm[98];
                            data_algorithm[99] = j==98 ?  swap : data_algorithm[99];
                            data_algorithm[100] = j==99 ?  swap : data_algorithm[100];
                            data_algorithm[101] = j==100 ?  swap : data_algorithm[101];
                            data_algorithm[102] = j==101 ?  swap : data_algorithm[102];
                            data_algorithm[103] = j==102 ?  swap : data_algorithm[103];
                            data_algorithm[104] = j==103 ?  swap : data_algorithm[104];
                            data_algorithm[105] = j==104 ?  swap : data_algorithm[105];
                            data_algorithm[106] = j==105 ?  swap : data_algorithm[106];
                            data_algorithm[107] = j==106 ?  swap : data_algorithm[107];
                            data_algorithm[108] = j==107 ?  swap : data_algorithm[108];
                            data_algorithm[109] = j==108 ?  swap : data_algorithm[109];
                            data_algorithm[110] = j==109 ?  swap : data_algorithm[110];
                            data_algorithm[111] = j==110 ?  swap : data_algorithm[111];
                            data_algorithm[112] = j==111 ?  swap : data_algorithm[112];
                            data_algorithm[113] = j==112 ?  swap : data_algorithm[113];
                            data_algorithm[114] = j==113 ?  swap : data_algorithm[114];
                            data_algorithm[115] = j==114 ?  swap : data_algorithm[115];
                            data_algorithm[116] = j==115 ?  swap : data_algorithm[116];
                            data_algorithm[117] = j==116 ?  swap : data_algorithm[117];
                            data_algorithm[118] = j==117 ?  swap : data_algorithm[118];
                            data_algorithm[119] = j==118 ?  swap : data_algorithm[119];
                            data_algorithm[120] = j==119 ?  swap : data_algorithm[120];
                            data_algorithm[121] = j==120 ?  swap : data_algorithm[121];
                            data_algorithm[122] = j==121 ?  swap : data_algorithm[122];
                            data_algorithm[123] = j==122 ?  swap : data_algorithm[123];
                            data_algorithm[124] = j==123 ?  swap : data_algorithm[124];
                            data_algorithm[125] = j==124 ?  swap : data_algorithm[125];
                            data_algorithm[126] = j==125 ?  swap : data_algorithm[126];
                            data_algorithm[127] = j==126 ?  swap : data_algorithm[127];

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


