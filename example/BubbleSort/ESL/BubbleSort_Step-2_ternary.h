//
// Created by Tobias Jauch on 26.05.2020
//
#include "../../Interfaces/Interfaces.h"
#include "systemc.h"
#include "DataTypes.h"


//#ifndef PROJECT_BUS_H
//#define PROJECT_BUS_H
#define ARRAY_SIZE 256

using namespace std;

struct BubbleSort : public sc_module {

    //Variables
    phases phase_algorithm;
    int i; //counter for outer loop
    int j; //counter for inner loop
    int swap; //buffer for swapping values

    //data
#define SLOW
#ifndef SLOW
    blocking_in< int*> data_in;
    blocking_out<int*> data_out;
    int data_ptr[ARRAY_SIZE];
    int * data_algorithm = data_ptr;
#else
    std::array<int,ARRAY_SIZE> data_algorithm;
    blocking_in< std::array<int,ARRAY_SIZE> >data_in;
    blocking_out< std::array<int,ARRAY_SIZE>> data_out;
#endif


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
//                            data_algorithm[j] = data_algorithm[j+1];
//                            for(auto w = 0;w<ARRAY_SIZE-1;w++){
//                                if(j == w){
//                                    data_algorithm[w] = data_algorithm[w+1];
//                                }
//                            }

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
                            data_algorithm[127] = j==127 ?  data_algorithm[128] : data_algorithm[127];
                            data_algorithm[128] = j==128 ?  data_algorithm[129] : data_algorithm[128];
                            data_algorithm[129] = j==129 ?  data_algorithm[130] : data_algorithm[129];
                            data_algorithm[130] = j==130 ?  data_algorithm[131] : data_algorithm[130];
                            data_algorithm[131] = j==131 ?  data_algorithm[132] : data_algorithm[131];
                            data_algorithm[132] = j==132 ?  data_algorithm[133] : data_algorithm[132];
                            data_algorithm[133] = j==133 ?  data_algorithm[134] : data_algorithm[133];
                            data_algorithm[134] = j==134 ?  data_algorithm[135] : data_algorithm[134];
                            data_algorithm[135] = j==135 ?  data_algorithm[136] : data_algorithm[135];
                            data_algorithm[136] = j==136 ?  data_algorithm[137] : data_algorithm[136];
                            data_algorithm[137] = j==137 ?  data_algorithm[138] : data_algorithm[137];
                            data_algorithm[138] = j==138 ?  data_algorithm[139] : data_algorithm[138];
                            data_algorithm[139] = j==139 ?  data_algorithm[140] : data_algorithm[139];
                            data_algorithm[140] = j==140 ?  data_algorithm[141] : data_algorithm[140];
                            data_algorithm[141] = j==141 ?  data_algorithm[142] : data_algorithm[141];
                            data_algorithm[142] = j==142 ?  data_algorithm[143] : data_algorithm[142];
                            data_algorithm[143] = j==143 ?  data_algorithm[144] : data_algorithm[143];
                            data_algorithm[144] = j==144 ?  data_algorithm[145] : data_algorithm[144];
                            data_algorithm[145] = j==145 ?  data_algorithm[146] : data_algorithm[145];
                            data_algorithm[146] = j==146 ?  data_algorithm[147] : data_algorithm[146];
                            data_algorithm[147] = j==147 ?  data_algorithm[148] : data_algorithm[147];
                            data_algorithm[148] = j==148 ?  data_algorithm[149] : data_algorithm[148];
                            data_algorithm[149] = j==149 ?  data_algorithm[150] : data_algorithm[149];
                            data_algorithm[150] = j==150 ?  data_algorithm[151] : data_algorithm[150];
                            data_algorithm[151] = j==151 ?  data_algorithm[152] : data_algorithm[151];
                            data_algorithm[152] = j==152 ?  data_algorithm[153] : data_algorithm[152];
                            data_algorithm[153] = j==153 ?  data_algorithm[154] : data_algorithm[153];
                            data_algorithm[154] = j==154 ?  data_algorithm[155] : data_algorithm[154];
                            data_algorithm[155] = j==155 ?  data_algorithm[156] : data_algorithm[155];
                            data_algorithm[156] = j==156 ?  data_algorithm[157] : data_algorithm[156];
                            data_algorithm[157] = j==157 ?  data_algorithm[158] : data_algorithm[157];
                            data_algorithm[158] = j==158 ?  data_algorithm[159] : data_algorithm[158];
                            data_algorithm[159] = j==159 ?  data_algorithm[160] : data_algorithm[159];
                            data_algorithm[160] = j==160 ?  data_algorithm[161] : data_algorithm[160];
                            data_algorithm[161] = j==161 ?  data_algorithm[162] : data_algorithm[161];
                            data_algorithm[162] = j==162 ?  data_algorithm[163] : data_algorithm[162];
                            data_algorithm[163] = j==163 ?  data_algorithm[164] : data_algorithm[163];
                            data_algorithm[164] = j==164 ?  data_algorithm[165] : data_algorithm[164];
                            data_algorithm[165] = j==165 ?  data_algorithm[166] : data_algorithm[165];
                            data_algorithm[166] = j==166 ?  data_algorithm[167] : data_algorithm[166];
                            data_algorithm[167] = j==167 ?  data_algorithm[168] : data_algorithm[167];
                            data_algorithm[168] = j==168 ?  data_algorithm[169] : data_algorithm[168];
                            data_algorithm[169] = j==169 ?  data_algorithm[170] : data_algorithm[169];
                            data_algorithm[170] = j==170 ?  data_algorithm[171] : data_algorithm[170];
                            data_algorithm[171] = j==171 ?  data_algorithm[172] : data_algorithm[171];
                            data_algorithm[172] = j==172 ?  data_algorithm[173] : data_algorithm[172];
                            data_algorithm[173] = j==173 ?  data_algorithm[174] : data_algorithm[173];
                            data_algorithm[174] = j==174 ?  data_algorithm[175] : data_algorithm[174];
                            data_algorithm[175] = j==175 ?  data_algorithm[176] : data_algorithm[175];
                            data_algorithm[176] = j==176 ?  data_algorithm[177] : data_algorithm[176];
                            data_algorithm[177] = j==177 ?  data_algorithm[178] : data_algorithm[177];
                            data_algorithm[178] = j==178 ?  data_algorithm[179] : data_algorithm[178];
                            data_algorithm[179] = j==179 ?  data_algorithm[180] : data_algorithm[179];
                            data_algorithm[180] = j==180 ?  data_algorithm[181] : data_algorithm[180];
                            data_algorithm[181] = j==181 ?  data_algorithm[182] : data_algorithm[181];
                            data_algorithm[182] = j==182 ?  data_algorithm[183] : data_algorithm[182];
                            data_algorithm[183] = j==183 ?  data_algorithm[184] : data_algorithm[183];
                            data_algorithm[184] = j==184 ?  data_algorithm[185] : data_algorithm[184];
                            data_algorithm[185] = j==185 ?  data_algorithm[186] : data_algorithm[185];
                            data_algorithm[186] = j==186 ?  data_algorithm[187] : data_algorithm[186];
                            data_algorithm[187] = j==187 ?  data_algorithm[188] : data_algorithm[187];
                            data_algorithm[188] = j==188 ?  data_algorithm[189] : data_algorithm[188];
                            data_algorithm[189] = j==189 ?  data_algorithm[190] : data_algorithm[189];
                            data_algorithm[190] = j==190 ?  data_algorithm[191] : data_algorithm[190];
                            data_algorithm[191] = j==191 ?  data_algorithm[192] : data_algorithm[191];
                            data_algorithm[192] = j==192 ?  data_algorithm[193] : data_algorithm[192];
                            data_algorithm[193] = j==193 ?  data_algorithm[194] : data_algorithm[193];
                            data_algorithm[194] = j==194 ?  data_algorithm[195] : data_algorithm[194];
                            data_algorithm[195] = j==195 ?  data_algorithm[196] : data_algorithm[195];
                            data_algorithm[196] = j==196 ?  data_algorithm[197] : data_algorithm[196];
                            data_algorithm[197] = j==197 ?  data_algorithm[198] : data_algorithm[197];
                            data_algorithm[198] = j==198 ?  data_algorithm[199] : data_algorithm[198];
                            data_algorithm[199] = j==199 ?  data_algorithm[200] : data_algorithm[199];
                            data_algorithm[200] = j==200 ?  data_algorithm[201] : data_algorithm[200];
                            data_algorithm[201] = j==201 ?  data_algorithm[202] : data_algorithm[201];
                            data_algorithm[202] = j==202 ?  data_algorithm[203] : data_algorithm[202];
                            data_algorithm[203] = j==203 ?  data_algorithm[204] : data_algorithm[203];
                            data_algorithm[204] = j==204 ?  data_algorithm[205] : data_algorithm[204];
                            data_algorithm[205] = j==205 ?  data_algorithm[206] : data_algorithm[205];
                            data_algorithm[206] = j==206 ?  data_algorithm[207] : data_algorithm[206];
                            data_algorithm[207] = j==207 ?  data_algorithm[208] : data_algorithm[207];
                            data_algorithm[208] = j==208 ?  data_algorithm[209] : data_algorithm[208];
                            data_algorithm[209] = j==209 ?  data_algorithm[210] : data_algorithm[209];
                            data_algorithm[210] = j==210 ?  data_algorithm[211] : data_algorithm[210];
                            data_algorithm[211] = j==211 ?  data_algorithm[212] : data_algorithm[211];
                            data_algorithm[212] = j==212 ?  data_algorithm[213] : data_algorithm[212];
                            data_algorithm[213] = j==213 ?  data_algorithm[214] : data_algorithm[213];
                            data_algorithm[214] = j==214 ?  data_algorithm[215] : data_algorithm[214];
                            data_algorithm[215] = j==215 ?  data_algorithm[216] : data_algorithm[215];
                            data_algorithm[216] = j==216 ?  data_algorithm[217] : data_algorithm[216];
                            data_algorithm[217] = j==217 ?  data_algorithm[218] : data_algorithm[217];
                            data_algorithm[218] = j==218 ?  data_algorithm[219] : data_algorithm[218];
                            data_algorithm[219] = j==219 ?  data_algorithm[220] : data_algorithm[219];
                            data_algorithm[220] = j==220 ?  data_algorithm[221] : data_algorithm[220];
                            data_algorithm[221] = j==221 ?  data_algorithm[222] : data_algorithm[221];
                            data_algorithm[222] = j==222 ?  data_algorithm[223] : data_algorithm[222];
                            data_algorithm[223] = j==223 ?  data_algorithm[224] : data_algorithm[223];
                            data_algorithm[224] = j==224 ?  data_algorithm[225] : data_algorithm[224];
                            data_algorithm[225] = j==225 ?  data_algorithm[226] : data_algorithm[225];
                            data_algorithm[226] = j==226 ?  data_algorithm[227] : data_algorithm[226];
                            data_algorithm[227] = j==227 ?  data_algorithm[228] : data_algorithm[227];
                            data_algorithm[228] = j==228 ?  data_algorithm[229] : data_algorithm[228];
                            data_algorithm[229] = j==229 ?  data_algorithm[230] : data_algorithm[229];
                            data_algorithm[230] = j==230 ?  data_algorithm[231] : data_algorithm[230];
                            data_algorithm[231] = j==231 ?  data_algorithm[232] : data_algorithm[231];
                            data_algorithm[232] = j==232 ?  data_algorithm[233] : data_algorithm[232];
                            data_algorithm[233] = j==233 ?  data_algorithm[234] : data_algorithm[233];
                            data_algorithm[234] = j==234 ?  data_algorithm[235] : data_algorithm[234];
                            data_algorithm[235] = j==245 ?  data_algorithm[236] : data_algorithm[235];
                            data_algorithm[236] = j==236 ?  data_algorithm[237] : data_algorithm[236];
                            data_algorithm[237] = j==237 ?  data_algorithm[238] : data_algorithm[237];
                            data_algorithm[238] = j==238 ?  data_algorithm[239] : data_algorithm[238];
                            data_algorithm[239] = j==239 ?  data_algorithm[240] : data_algorithm[239];
                            data_algorithm[240] = j==240 ?  data_algorithm[241] : data_algorithm[240];
                            data_algorithm[241] = j==241 ?  data_algorithm[242] : data_algorithm[241];
                            data_algorithm[242] = j==242 ?  data_algorithm[243] : data_algorithm[242];
                            data_algorithm[243] = j==243 ?  data_algorithm[244] : data_algorithm[243];
                            data_algorithm[244] = j==244 ?  data_algorithm[245] : data_algorithm[244];
                            data_algorithm[245] = j==245 ?  data_algorithm[246] : data_algorithm[245];
                            data_algorithm[246] = j==246 ?  data_algorithm[247] : data_algorithm[246];
                            data_algorithm[247] = j==247 ?  data_algorithm[248] : data_algorithm[247];
                            data_algorithm[248] = j==248 ?  data_algorithm[249] : data_algorithm[248];
                            data_algorithm[249] = j==249 ?  data_algorithm[250] : data_algorithm[249];
                            data_algorithm[250] = j==250 ?  data_algorithm[251] : data_algorithm[250];
                            data_algorithm[251] = j==251 ?  data_algorithm[252] : data_algorithm[251];
                            data_algorithm[252] = j==252 ?  data_algorithm[253] : data_algorithm[252];
                            data_algorithm[253] = j==253 ?  data_algorithm[254] : data_algorithm[253];
                            data_algorithm[254] = j==254 ?  data_algorithm[255] : data_algorithm[254];


//                            data_algorithm[j+1] = swap;
//                            for(auto w=0;w<ARRAY_SIZE-1;w++){
//                                if(w==j){
//                                    data_algorithm[w+1] = swap;
//                                }
//                            }

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
                            data_algorithm[76] = j==75 ?  swap : data_algorithm[76];                                //data_algorithm[1] = j==0 ?  swap : data_algorithm[1];
                            data_algorithm[77] = j==76 ?  swap : data_algorithm[77];
                            data_algorithm[78] = j==77 ?  swap : data_algorithm[78];
                            data_algorithm[79] = j==78 ?  swap : data_algorithm[79];
                            data_algorithm[80] = j==79 ?  swap : data_algorithm[80];
                            data_algorithm[81] = j==80 ?  swap : data_algorithm[81];
                            data_algorithm[82] = j==81 ?  swap : data_algorithm[82];
                            data_algorithm[83] = j==82 ?  swap : data_algorithm[83];                                //data_algorithm[1] = j==0 ?  swap : data_algorithm[1];
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
                            data_algorithm[128] = j==127 ?  swap : data_algorithm[128];
                            data_algorithm[129] = j==128 ?  swap : data_algorithm[129];
                            data_algorithm[130] = j==129 ?  swap : data_algorithm[130];
                            data_algorithm[131] = j==130 ?  swap : data_algorithm[131];
                            data_algorithm[132] = j==131 ?  swap : data_algorithm[132];
                            data_algorithm[133] = j==132 ?  swap : data_algorithm[133];
                            data_algorithm[134] = j==133 ?  swap : data_algorithm[134];
                            data_algorithm[135] = j==134 ?  swap : data_algorithm[135];
                            data_algorithm[136] = j==135 ?  swap : data_algorithm[136];
                            data_algorithm[137] = j==136 ?  swap : data_algorithm[137];
                            data_algorithm[138] = j==137 ?  swap : data_algorithm[138];
                            data_algorithm[139] = j==138 ?  swap : data_algorithm[139];
                            data_algorithm[140] = j==139 ?  swap : data_algorithm[140];
                            data_algorithm[141] = j==140 ?  swap : data_algorithm[141];
                            data_algorithm[142] = j==141 ?  swap : data_algorithm[142];
                            data_algorithm[143] = j==142 ?  swap : data_algorithm[143];
                            data_algorithm[144] = j==143 ?  swap : data_algorithm[144];
                            data_algorithm[145] = j==144 ?  swap : data_algorithm[145];
                            data_algorithm[146] = j==145 ?  swap : data_algorithm[146];
                            data_algorithm[147] = j==146 ?  swap : data_algorithm[147];
                            data_algorithm[148] = j==147 ?  swap : data_algorithm[148];
                            data_algorithm[149] = j==148 ?  swap : data_algorithm[149];
                            data_algorithm[150] = j==149 ?  swap : data_algorithm[150];
                            data_algorithm[151] = j==150 ?  swap : data_algorithm[151];
                            data_algorithm[152] = j==151 ?  swap : data_algorithm[152];
                            data_algorithm[153] = j==152 ?  swap : data_algorithm[153];
                            data_algorithm[154] = j==153 ?  swap : data_algorithm[154];
                            data_algorithm[155] = j==154 ?  swap : data_algorithm[155];
                            data_algorithm[156] = j==155 ?  swap : data_algorithm[156];
                            data_algorithm[157] = j==156 ?  swap : data_algorithm[157];
                            data_algorithm[158] = j==157 ?  swap : data_algorithm[158];
                            data_algorithm[159] = j==158 ?  swap : data_algorithm[159];
                            data_algorithm[160] = j==159 ?  swap : data_algorithm[160];
                            data_algorithm[161] = j==160 ?  swap : data_algorithm[161];
                            data_algorithm[162] = j==161 ?  swap : data_algorithm[162];
                            data_algorithm[163] = j==162 ?  swap : data_algorithm[163];
                            data_algorithm[164] = j==163 ?  swap : data_algorithm[164];
                            data_algorithm[165] = j==164 ?  swap : data_algorithm[165];
                            data_algorithm[166] = j==165 ?  swap : data_algorithm[166];
                            data_algorithm[167] = j==166 ?  swap : data_algorithm[167];
                            data_algorithm[168] = j==167 ?  swap : data_algorithm[168];
                            data_algorithm[169] = j==168 ?  swap : data_algorithm[169];
                            data_algorithm[170] = j==169 ?  swap : data_algorithm[170];
                            data_algorithm[171] = j==170 ?  swap : data_algorithm[171];
                            data_algorithm[172] = j==171 ?  swap : data_algorithm[172];
                            data_algorithm[173] = j==172 ?  swap : data_algorithm[173];
                            data_algorithm[174] = j==173 ?  swap : data_algorithm[174];
                            data_algorithm[175] = j==174 ?  swap : data_algorithm[175];
                            data_algorithm[176] = j==175 ?  swap : data_algorithm[176];
                            data_algorithm[177] = j==176 ?  swap : data_algorithm[177];
                            data_algorithm[178] = j==177 ?  swap : data_algorithm[178];
                            data_algorithm[179] = j==178 ?  swap : data_algorithm[179];
                            data_algorithm[180] = j==179 ?  swap : data_algorithm[180];
                            data_algorithm[181] = j==180 ?  swap : data_algorithm[181];
                            data_algorithm[182] = j==181 ?  swap : data_algorithm[182];
                            data_algorithm[183] = j==182 ?  swap : data_algorithm[183];
                            data_algorithm[184] = j==183 ?  swap : data_algorithm[184];
                            data_algorithm[185] = j==184 ?  swap : data_algorithm[185];
                            data_algorithm[186] = j==185 ?  swap : data_algorithm[186];
                            data_algorithm[187] = j==186 ?  swap : data_algorithm[187];
                            data_algorithm[188] = j==187 ?  swap : data_algorithm[188];
                            data_algorithm[189] = j==188 ?  swap : data_algorithm[189];
                            data_algorithm[190] = j==189 ?  swap : data_algorithm[190];
                            data_algorithm[191] = j==190 ?  swap : data_algorithm[191];
                            data_algorithm[192] = j==191 ?  swap : data_algorithm[192];
                            data_algorithm[193] = j==192 ?  swap : data_algorithm[193];
                            data_algorithm[194] = j==193 ?  swap : data_algorithm[194];
                            data_algorithm[195] = j==194 ?  swap : data_algorithm[195];
                            data_algorithm[196] = j==195 ?  swap : data_algorithm[196];
                            data_algorithm[197] = j==196 ?  swap : data_algorithm[197];
                            data_algorithm[198] = j==197 ?  swap : data_algorithm[198];
                            data_algorithm[199] = j==198 ?  swap : data_algorithm[199];
                            data_algorithm[200] = j==199 ?  swap : data_algorithm[200];
                            data_algorithm[201] = j==200 ?  swap : data_algorithm[201];
                            data_algorithm[202] = j==201 ?  swap : data_algorithm[202];
                            data_algorithm[203] = j==202 ?  swap : data_algorithm[203];
                            data_algorithm[204] = j==203 ?  swap : data_algorithm[204];
                            data_algorithm[205] = j==204 ?  swap : data_algorithm[205];
                            data_algorithm[206] = j==205 ?  swap : data_algorithm[206];
                            data_algorithm[207] = j==206 ?  swap : data_algorithm[207];
                            data_algorithm[208] = j==207 ?  swap : data_algorithm[208];
                            data_algorithm[209] = j==208 ?  swap : data_algorithm[209];
                            data_algorithm[210] = j==209 ?  swap : data_algorithm[210];
                            data_algorithm[211] = j==210 ?  swap : data_algorithm[211];
                            data_algorithm[212] = j==211 ?  swap : data_algorithm[212];
                            data_algorithm[213] = j==212 ?  swap : data_algorithm[213];
                            data_algorithm[214] = j==213 ?  swap : data_algorithm[214];
                            data_algorithm[215] = j==214 ?  swap : data_algorithm[215];
                            data_algorithm[216] = j==215 ?  swap : data_algorithm[216];
                            data_algorithm[217] = j==216 ?  swap : data_algorithm[217];
                            data_algorithm[218] = j==217 ?  swap : data_algorithm[218];
                            data_algorithm[219] = j==218 ?  swap : data_algorithm[219];
                            data_algorithm[220] = j==219 ?  swap : data_algorithm[220];
                            data_algorithm[221] = j==220 ?  swap : data_algorithm[221];
                            data_algorithm[222] = j==221 ?  swap : data_algorithm[222];
                            data_algorithm[223] = j==222 ?  swap : data_algorithm[223];
                            data_algorithm[224] = j==223 ?  swap : data_algorithm[224];
                            data_algorithm[225] = j==224 ?  swap : data_algorithm[225];
                            data_algorithm[226] = j==225 ?  swap : data_algorithm[226];
                            data_algorithm[227] = j==226 ?  swap : data_algorithm[227];
                            data_algorithm[228] = j==227 ?  swap : data_algorithm[228];
                            data_algorithm[229] = j==228 ?  swap : data_algorithm[229];
                            data_algorithm[230] = j==229 ?  swap : data_algorithm[230];
                            data_algorithm[231] = j==230 ?  swap : data_algorithm[231];
                            data_algorithm[232] = j==231 ?  swap : data_algorithm[232];
                            data_algorithm[233] = j==232 ?  swap : data_algorithm[233];
                            data_algorithm[234] = j==233 ?  swap : data_algorithm[234];
                            data_algorithm[235] = j==234 ?  swap : data_algorithm[235];
                            data_algorithm[236] = j==235 ?  swap : data_algorithm[236];
                            data_algorithm[237] = j==236 ?  swap : data_algorithm[237];
                            data_algorithm[238] = j==237 ?  swap : data_algorithm[238];
                            data_algorithm[239] = j==238 ?  swap : data_algorithm[239];
                            data_algorithm[240] = j==239 ?  swap : data_algorithm[240];
                            data_algorithm[241] = j==240 ?  swap : data_algorithm[241];
                            data_algorithm[242] = j==241 ?  swap : data_algorithm[242];
                            data_algorithm[243] = j==242 ?  swap : data_algorithm[243];
                            data_algorithm[244] = j==243 ?  swap : data_algorithm[244];
                            data_algorithm[245] = j==244 ?  swap : data_algorithm[245];
                            data_algorithm[246] = j==245 ?  swap : data_algorithm[246];
                            data_algorithm[247] = j==246 ?  swap : data_algorithm[247];
                            data_algorithm[248] = j==247 ?  swap : data_algorithm[248];
                            data_algorithm[249] = j==248 ?  swap : data_algorithm[249];
                            data_algorithm[250] = j==249 ?  swap : data_algorithm[250];
                            data_algorithm[251] = j==250 ?  swap : data_algorithm[251];
                            data_algorithm[252] = j==251 ?  swap : data_algorithm[252];
                            data_algorithm[253] = j==252 ?  swap : data_algorithm[253];
                            data_algorithm[254] = j==253 ?  swap : data_algorithm[254];
                            data_algorithm[255] = j==254 ?  swap : data_algorithm[255];

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


